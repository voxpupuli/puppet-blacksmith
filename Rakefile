require 'rake'
require 'rake/clean'
require 'rubygems'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'fileutils'

CLEAN.include("pkg/", "tmp/")
CLOBBER.include("Gemfile.lock")

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'puppet_blacksmith/version'

task :default => [:clean, :spec, :cucumber, :build]

RSpec::Core::RakeTask.new
Cucumber::Rake::Task.new(:cucumber) do |t|
  if Gem::Version.new(ENV['PUPPET_VERSION']) < Gem::Version.new("3.6.0")
    t.cucumber_opts = "--tags ~@metadatajson"
  end
end

task :bump do
  v = Gem::Version.new("#{Blacksmith::VERSION}.0")
  fail("Unable to increase prerelease version #{Blacksmith::VERSION}") if v.prerelease?
  s = <<-EOS
module Blacksmith
  VERSION = #{v.bump.to_s}
end
EOS

  File.open("lib/puppet_blacksmith/version.rb", "w") do |file|
    file.print s
  end
  sh "git add version"
  sh "git commit -m 'Bump version'"
end
