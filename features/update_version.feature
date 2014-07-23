Feature: update_version
  puppet-blacksmith needs to update module versions

  Scenario: Bumping a module version when using Modulefile
    Given a file named "Rakefile" with:
    """
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
    And a file named "metadata.json" should not exist


  Scenario: Bumping a module version when using metadata.json
    Given a file named "Rakefile" with:
    """
    require 'puppetlabs_spec_helper/rake_tasks'
    require "#{File.dirname(__FILE__)}/../../lib/puppet_blacksmith/rake_tasks"
    """
    And a file named "metadata.json" with:
    """
    {
      "operatingsystem_support": [
        {
          "operatingsystem": "CentOS",
          "operatingsystemrelease": [
            "4",
            "5",
            "6"
          ]
        }
      ],
      "requirements": [
        {
          "name": "pe",
          "version_requirement": "3.2.x"
        },
        {
          "name": "puppet",
          "version_requirement": ">=2.7.20 <4.0.0"
        }
      ],
      "name": "maestrodev-test",
      "version": "1.0.0",
      "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
      "author": "maestrodev",
      "license": "Apache 2.0",
      "summary": "Puppet Module Standard Library",
      "description": "Standard Library for Puppet Modules",
      "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
      "dependencies": [
      ]
    }
    """
    When I run `rake module:bump`
    Then the exit status should be 0
    And the file "metadata.json" should contain:
    """
    {
      "operatingsystem_support": [
        {
          "operatingsystem": "CentOS",
          "operatingsystemrelease": [
            "4",
            "5",
            "6"
          ]
        }
      ],
      "requirements": [
        {
          "name": "pe",
          "version_requirement": "3.2.x"
        },
        {
          "name": "puppet",
          "version_requirement": ">=2.7.20 <4.0.0"
        }
      ],
      "name": "maestrodev-test",
      "version": "1.0.1",
      "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
      "author": "maestrodev",
      "license": "Apache 2.0",
      "summary": "Puppet Module Standard Library",
      "description": "Standard Library for Puppet Modules",
      "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
    """
    And a file named "Modulefile" should not exist
