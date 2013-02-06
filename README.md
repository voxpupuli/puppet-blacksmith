puppet-blacksmith
=================

Ruby Gem with several Puppet Module utilities

# Rake tasks

## Installation

Add to your Rakefile

    require 'puppet_blacksmith/rake_tasks'

And you can start using the Rake tasks

## Bump the version of a module

Bump your Modulefile to the next version

    $ rake module:bump

## Push a module to the Puppet Forge

Configure your credentials in ~/.puppetforge.yml

    --- 
    forge: https://forge.puppetlabs.com
    username: myuser
    password: mypassword


Remember to [create the project at the Forge](http://forge.puppetlabs.com/modules/new)

The Rakefile:

    # Rakefile
    require 'puppetlabs_spec_helper/rake_tasks'
    require 'puppet_blacksmith/rake_tasks'

Run rake. Ensure you are doing it in a clean working folder or the puppet module tool will package all the unnecessary files.

    $ rake module:push

# Building blacksmith

    bundle install
    bundle exec rake

To cut a release: builds the gem, tags with git, pushes to rubygems and bumps the version number

    bundle exec rake release
