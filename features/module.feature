Feature: module
  puppet-blacksmith needs to build a module

  Scenario: Building a module with metadata.json
    Given a file named "Rakefile" with:
    """
    require "#{__dir__}/../../lib/puppet_blacksmith/rake_tasks"
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
          "version_requirement": ">=2.7.20 <7.0.0"
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
    When I run `rake module:build`
    Then the exit status should be 0
    And a file named "pkg/maestrodev-test-1.0.0.tar.gz" should exist
