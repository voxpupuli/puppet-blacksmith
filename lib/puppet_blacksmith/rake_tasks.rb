require 'rake'
require 'puppet_blacksmith'

namespace :module do
  desc "Bump module version to the next minor"
  task :bump do
    m = Blacksmith::Modulefile.new
    v = m.bump!
    puts "Bumping version from #{m.version} to #{v}"
  end

  desc "Git tag with the current module version"
  task :tag do
    m = Blacksmith::Modulefile.new
    Blacksmith::Git.new.tag!(m.version)
  end

  desc "Bump version and git commit"
  task :bump_commit => :bump do
    m = Blacksmith::Modulefile.new
    Blacksmith::Git.new.commit_modulefile!(m.version)
  end

  desc "Push module to the Puppet Forge"
  task :push => :build do
    m = Blacksmith::Modulefile.new
    forge = Blacksmith::Forge.new
    puts "Uploading to Puppet Forge #{forge.username}/#{m.name}"
    forge.push!(m.name)
  end

  desc "Runs clean again"
  task :clean do
    puts "Cleaning for module build"
    Rake::Task["clean"].execute
  end

  desc "Release the Puppet module, doing a clean, build, tag, push, bump_commit and git push."
  task :release => [:clean, :build, :tag, :push, :bump_commit] do
    puts "Pushing to remote git repo"
    Blacksmith::Git.new.push!
  end

  desc "Set specific module dependency version"
  task :dependency, [:module_name, :version] do |t, args|
    mn = args[:module_name]
    mv = args[:version]
    m = Blacksmith::Modulefile.new
    m.bump_dep! mn, mv
    puts "Updated module dependency #{mn} to #{mv}"
  end
end
