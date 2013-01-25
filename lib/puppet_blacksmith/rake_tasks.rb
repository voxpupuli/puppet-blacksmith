require 'rake'
require 'rest-client'
require 'puppet'
require 'yaml'

namespace :module do
  desc "Bump module version to the next minor"
  task :bump do
    m = modulefile()
    text = File.read("Modulefile")
    v = increase_version(m.version)
    puts "Bumping version from #{m.version} to #{v}"
    text = replace_version(text, v)
    File.open("Modulefile", "w") {|file| file.puts text}
  end

  desc "Git tag with the current module version"
  task :tag do
    m = modulefile()
    sh "git tag v#{m.version}"
  end

  desc "Bump version and git commit"
  task :bump_commit => :bump do
    sh "git add Modulefile"
    sh "git commit -m 'Bump version'"
  end

  desc "Push module to the Puppet Forge"
  task :push => :build do
    credentials_file = File.expand_path("~/.puppetforge.yml")
    unless File.exists?(credentials_file)
      fail("Could not find Puppet Forge credentials file '#{credentials_file}'
Please create it
--- 
forge: https://forge.puppetlabs.com
username: myuser
password: mypassword")
    end
    credentials = YAML.load_file(credentials_file)
    m = modulefile("Modulefile")
    forge = credentials['forge'] || "https://forge.puppetlabs.com"

    # login to the puppet forge
    response = RestClient.post(
      "#{forge}/login",
      {'username' => credentials['username'], 'password' => credentials['password']}){
        |response, request, result, &block|
        if [301, 302, 307].include? response.code
          response
        else
          response.return!(request, result, &block)
        end
    }
    # TODO check response body for errors

    # upload the file
    RestClient.post("#{forge}/#{m.username}/#{m.name}/upload",
      {:notes => "Auto uploaded", :tarball => File.new("pkg/#{m.username}-#{m.name}-#{m.version}.tar.gz", 'rb') },
      {:cookies => response.cookies})
    # TODO check response body for errors
  end
end

def replace_version(text, version)
  text.gsub(/\nversion[ ]+['"].*['"]/, "\nversion '#{version}'")
end

def increase_version(version)
  v = Gem::Version.new("#{version}.0")
  raise "Unable to increase prerelease version #{version}" if v.prerelease?
  v.bump.to_s
end

def modulefile(path = "Modulefile")
  metadata = Puppet::ModuleTool::Metadata.new
  Puppet::ModuleTool::ModulefileReader.evaluate(metadata, path)
  metadata
end
