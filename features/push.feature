Feature: push
  puppet-blacksmith needs to push modules to the Puppet Forge

  @skip
  Scenario: Pushing a module
    Given a file named "Rakefile" with:
    """
    require 'puppetlabs_spec_helper/rake_tasks'
    require "#{File.dirname(__FILE__)}/../../lib/puppet_blacksmith/rake_tasks"
    """
    And a file named "Modulefile" with:
    """
    name 'maestrodev-test'
    version '1.0.0'

    author 'maestrodev'
    license 'Apache License, Version 2.0'
    project_page 'http://github.com/maestrodev/puppet-blacksmith'
    source 'http://github.com/maestrodev/puppet-blacksmith'
    summary 'Testing Puppet module operations'
    description 'Testing Puppet module operations'
    """
    When I run `rake module:push`
    Then the exit status should be 0
