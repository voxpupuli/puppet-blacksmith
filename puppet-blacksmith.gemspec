# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_blacksmith/version'

Gem::Specification.new do |s|
  s.name = "puppet-blacksmith"
  s.version = Blacksmith::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["MaestroDev", "Vox Pupuli"]
  s.date = Time.now.getutc.strftime "%Y-%m-%d"
  s.summary = "Tasks to manage Puppet module builds"
  s.description = "Puppet module tools for development and Puppet Forge management"
  s.email = ["voxpupuli@groups.io"]
  s.homepage = "http://github.com/voxpupuli/puppet-blacksmith"
  s.license = 'Apache-2.0'
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.4.0'

  s.add_runtime_dependency 'puppet-modulebuilder', '>= 0.2', '< 2.0'
  s.add_runtime_dependency 'rest-client', '~>2.0'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'puppet', '>=2.7.16'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'rspec', '>=3.0.0'
  s.add_development_dependency 'webmock', '>= 2.0', '< 4'

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end
