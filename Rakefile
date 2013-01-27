require 'rake'
require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'fileutils'

CLEAN.include("pkg/", "tmp/")
CLOBBER.include("Gemfile.lock")

task :default => [:clean, :spec, :cucumber, :package]

RSpec::Core::RakeTask.new
Cucumber::Rake::Task.new

def timestamp_version
  "#{File.read("version")}.#{Time.now.getutc.strftime "%Y%m%d%H%M%S"}"
end

spec = Gem::Specification.new do |s|
  s.name = "puppet-blacksmith"
  s.version = timestamp_version

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["MaestroDev"]
  s.date = Time.now.getutc.strftime "%Y-%m-%d"
  s.summary = "Tasks to manage Puppet module builds"
  s.description = "Puppet module tools for development and Puppet Forge management"
  s.email = ["info@maestrodev.com"]
  s.homepage = "http://github.com/maestrodev/puppet-blacksmith"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"

  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'puppet', '>=2.7.16'
  s.add_runtime_dependency 'puppetlabs_spec_helper', '>=0.3.0'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
  s.add_development_dependency "rspec", '>=2.7.0'

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end

def build_gem(spec, pkgdir="pkg")
  g = Gem::Builder.new(spec).build
  mkdir pkgdir
  mv g, pkgdir
  "#{pkgdir}/#{g}"
end

task :package do
  build_gem(spec)
end

task :release => [:clean, :spec, :cucumber] do
  version = File.read("version")
  sh "git tag v#{version}"
  spec.version = version
  g = build_gem(spec)
  sh "gem push #{g}"
  v = Gem::Version.new("#{version}.0")
  raise "Unable to increase prerelease version #{version}" if v.prerelease?
  File.open("version", "w") {|file| file.print v.bump.to_s}
  sh "git add version"
  sh "git commit -m 'Bump version'"
end
