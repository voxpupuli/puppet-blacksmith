require 'rake'
require 'rest-client'
require 'puppet'
require 'yaml'
require 'nokogiri'

namespace :module do
  desc "Bump module version to the next minor"
  task :bump do
    bump
  end

  desc "Git tag with the current module version"
  task :tag do
    tag
  end

  desc "Bump version and git commit"
  task :bump_commit => :bump do
    bump_commit
  end

  desc "Push module to the Puppet Forge"
  task :push => :build do
    push
  end

  desc "Runs clean again"
  task :clean do
    puts "Cleaning for module build"
    Rake::Task["clean"].execute
  end

  desc "Release the Puppet module, doing a clean, build, tag, push, bump_commit and git push."
  task :release => [:clean, :build, :tag, :push, :bump_commit] do
    puts "Pushing commits to remote git repo"
    sh "git push"
    puts "Pushing tags to remote git repo"
    sh "git push --tags"
  end
end


# task methods for reuse

def bump
  m = modulefile()
  text = File.read("Modulefile")
  v = increase_version(m.version)
  puts "Bumping version from #{m.version} to #{v}"
  text = replace_version(text, v)
  File.open("Modulefile", "w") {|file| file.puts text}
end

def tag
  m = modulefile()
  sh "git tag v#{m.version}"
end

def bump_commit
  sh "git add Modulefile"
  sh "git commit -m 'Bump version'"
end

def bump_commit_push
  sh "git add Modulefile"
  sh "git commit -m 'Bump version'"
end

def push
  RestClient.proxy = ENV['http_proxy']
  credentials_file = File.expand_path("~/.puppetforge.yml")
  unless File.exists?(credentials_file)
    fail(<<-eos)
Could not find Puppet Forge credentials file '#{credentials_file}'
Please create it
--- 
forge: https://forge.puppetlabs.com
username: myuser
password: mypassword
eos
  end
  credentials = YAML.load_file(credentials_file)
  m = modulefile("Modulefile")
  forge = credentials['forge'] || "https://forge.puppetlabs.com"

  # login to the puppet forge
  puts "Logging into Puppet Forge as user #{credentials['username']}"
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
  fail("Failed to login to Puppet Forge: cookies not set correctly") unless response.cookies['auth']

  # upload the file
  package = "pkg/#{m.username}-#{m.name}-#{m.version}.tar.gz"
  puts "Uploading #{package} to Puppet Forge #{m.username}/#{m.name}"
  response = RestClient.post("#{forge}/#{m.username}/#{m.name}/upload",
    {:tarball => File.new(package, 'rb')},
    {:cookies => response.cookies}){
      |response, request, result, &block|
      if [301, 302, 307].include? response.code
        response
      else
        response.return!(request, result, &block)
      end
  }
  page = Nokogiri::HTML(response.body)
  errors = page.css('.errors')
  fail("Error uploading module #{package} to Puppet Forge #{m.username}/#{m.name}:#{errors.text}") unless errors.empty?
end


# util

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
