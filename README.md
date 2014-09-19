puppet-blacksmith
=================

[![Build Status](https://maestro.maestrodev.com/api/v1/projects/67/compositions/326/badge/icon)](https://maestro.maestrodev.com/projects/67/compositions/326)
[![Build Status](https://travis-ci.org/maestrodev/puppet-blacksmith.svg?branch=master)](https://travis-ci.org/maestrodev/puppet-blacksmith)

Ruby Gem with several Puppet Module utilities

![I don't always release my Puppet modules, but when I do I push them directly to the Forge](https://raw.github.com/maestrodev/puppet-blacksmith/gh-pages/dos-equis.jpg)

# Rake tasks

## Installation

Install the gem

	gem install puppet-blacksmith

Add to your Rakefile

    require 'puppet_blacksmith/rake_tasks'

And you can start using the Rake tasks

## Bump the version of a module

Bump your `Modulefile` or `metadata.json` to the next version

    $ rake module:bump

## Push a module to the Puppet Forge

Configure your credentials in `~/.puppetforge.yml`

    --- 
    url: https://forge.puppetlabs.com
    username: myuser
    password: mypassword


Remember to [create the project at the Forge](http://forge.puppetlabs.com/modules/new)

Add the require instructions for blacksmith and the puppetlabs_spec_helper to the Rakefile

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
