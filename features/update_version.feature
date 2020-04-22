Feature: update_version
  puppet-blacksmith needs to update module versions

  Scenario: Bumping a module version when using metadata.json
    Given a file named "Rakefile" with:
    """
    require 'puppetlabs_spec_helper/rake_tasks'
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
          "version_requirement": ">=2.7.20 <7.0.0"
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


  Scenario: Bumping a module patch version when using metadata.json
    Given a file named "Rakefile" with:
    """
    require 'puppetlabs_spec_helper/rake_tasks'
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
    When I run `rake module:bump:patch`
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


  Scenario: Bumping a module minor version when using metadata.json
    Given a file named "Rakefile" with:
    """
    require 'puppetlabs_spec_helper/rake_tasks'
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
    When I run `rake module:bump:minor`
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
      "version": "1.1.0",
      "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
      "author": "maestrodev",
      "license": "Apache 2.0",
      "summary": "Puppet Module Standard Library",
      "description": "Standard Library for Puppet Modules",
      "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
    """


  Scenario: Bumping a module major version when using metadata.json
    Given a file named "Rakefile" with:
    """
    require 'puppetlabs_spec_helper/rake_tasks'
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
    When I run `rake module:bump:major`
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
      "version": "2.0.0",
      "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
      "author": "maestrodev",
      "license": "Apache 2.0",
      "summary": "Puppet Module Standard Library",
      "description": "Standard Library for Puppet Modules",
      "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
    """


    Scenario: Bumping to exact module version when using metadata.json
      Given a file named "Rakefile" with:
      """
      require 'puppetlabs_spec_helper/rake_tasks'
      require "#{__dir__}/../../lib/puppet_blacksmith/rake_tasks"
      """
      And I set the environment variables to:
        | variable | value |
        | BLACKSMITH_FULL_VERSION | 2.1.3 |
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
      When I run `rake module:bump:full`
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
        "version": "2.1.3",
        "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
        "author": "maestrodev",
        "license": "Apache 2.0",
        "summary": "Puppet Module Standard Library",
        "description": "Standard Library for Puppet Modules",
        "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
      """


      Scenario: Bumping to exact module version but not setting the environment variable when using metadata.json
        Given a file named "Rakefile" with:
        """
        require 'puppetlabs_spec_helper/rake_tasks'
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
        When I run `rake module:bump:full`
        Then the exit status should be 1
        And the output should contain "Setting the full version requires setting the "
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
        """
