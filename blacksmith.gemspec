# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_blacksmith/version'

Gem::Specification.new do |s|
  s.name = "puppet-blacksmith"
  s.version = Blacksmith::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["MaestroDev"]
  s.date = Time.now.getutc.strftime "%Y-%m-%d"
  s.summary = "Tasks to manage Puppet module builds"
  s.description = "Puppet module tools for development and Puppet Forge management"
  s.email = ["info@maestrodev.com"]
  s.homepage = "http://github.com/maestrodev/puppet-blacksmith"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"

  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'puppet', '>=2.7.16'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'puppetlabs_spec_helper'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'rspec', '>=3.0.0'
  s.add_development_dependency 'webmock'

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE)
  s.test_files    = Dir.glob("spec/**/*")
  s.require_paths = ["lib"]
end
