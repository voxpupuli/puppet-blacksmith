Feature: update_dependency_version
  puppet-blacksmith needs to update module dependency versions

  Scenario: Bumping a module dependency version when using metadata.json
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
        {
          "name": "puppetlabs-stdlib",
          "version_requirement": ">= 3.0.0"
        }
      ]
    }
    """
    When I run `rake module:dependency["puppetlabs-stdlib",">= 4.0.0"]`
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
      "version": "1.0.0",
      "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
      "author": "maestrodev",
      "license": "Apache 2.0",
      "summary": "Puppet Module Standard Library",
      "description": "Standard Library for Puppet Modules",
      "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
      "dependencies": [
        {
          "name": "puppetlabs-stdlib",
          "version_requirement": ">= 4.0.0"
        }
      ]
    """
