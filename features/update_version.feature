Feature: update_version
  puppet-blacksmith needs to update module versions

  Scenario: Bumping a module version
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
    When I run `rake module:bump`
    Then the exit status should be 0
    And the file "Modulefile" should contain:
    """
    name 'maestrodev-test'
    version '1.0.1'

    author 'maestrodev'
    license 'Apache License, Version 2.0'
    project_page 'http://github.com/maestrodev/puppet-blacksmith'
    source 'http://github.com/maestrodev/puppet-blacksmith'
    summary 'Testing Puppet module operations'
    description 'Testing Puppet module operations'
    """
