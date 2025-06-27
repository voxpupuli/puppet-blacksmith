puppet-blacksmith
=================

[![License](https://img.shields.io/github/license/voxpupuli/puppet-blacksmith.svg)](https://github.com/voxpupuli/puppet-blacksmith/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/puppet-blacksmith/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/puppet-blacksmith/actions/workflows/test.yml)
[![Release](https://github.com/voxpupuli/puppet-blacksmith/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-blacksmith/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/puppet-blacksmith.svg)](https://rubygems.org/gems/puppet-blacksmith)
[![RubyGem Downloads](https://img.shields.io/gem/dt/puppet-blacksmith.svg)](https://rubygems.org/gems/puppet-blacksmith)
[![Donated by Carlos Sanchez](https://img.shields.io/badge/donated%20by-Carlos%20Sanchez-fb7047.svg)](#transfer-notice)

Ruby Gem with several Puppet Module utilities

![I don't always release my Puppet modules, but when I do I push them directly to the Forge](https://raw.github.com/voxpupuli/puppet-blacksmith/gh-pages/dos-equis.jpg)

# Rake tasks

## Installation

Install the gem

```console
$ gem install puppet-blacksmith
```

Add to your Rakefile

```ruby
require 'puppet_blacksmith/rake_tasks'
```

And you can start using the Rake tasks. Note that you might have to delete `.rake_t_cache`
before the tasks appear in the output of `rake -T`.

## Tasks

Rake tasks included:

| task               | description |
| ------------------ | ----------- |
| module:build       | Build the module using puppet-modulebuilder |
| module:bump        | Bump module version to the next patch |
| module:bump:patch  | Bump module version to the next patch |
| module:bump:minor  | Bump module version to the next minor version |
| module:bump:major  | Bump module version to the next major version |
| module:bump:full   | Bump module version to the version set in the BLACKSMITH_FULL_VERSION env variable |
| module:bump_commit | Bump version and git commit |
| module:bump_commit:patch  | Bump module version to the next patch and git commit |
| module:bump_commit:minor  | Bump module version to the next minor version and git commit |
| module:bump_commit:major  | Bump module version to the next major version and git commit |
| module:bump_commit:full   | Bump module version to the version set in the BLACKSMITH_FULL_VERSION env variable and git commit |
| module:bump_to_version\[:new\_version\] | Bump module version to _new\_version_ |
| module:clean       | Runs clean again |
| module:dependency[modulename, version] | Updates the module version of a specific dependency |
| module:push        | Push module to the Puppet Forge |
| module:release     | Release the Puppet module, doing a clean, build, bump_commit, tag, push and git push |
| module:tag         | Git tag with the current module version |
| module:version     | Get the current module version |
| module:version:next | Get the next patch module version |
| module:version:next:patch | Get the next patch module version |
| module:version:next:minor | Get the next minor module version |
| module:version:next:major | Get the next major module version |

### Full release

Do everything needed to push to the Forge with just one command

```console
$ rake module:release
```

### Bump the version of a module

Bump your `metadata.json` to the next version

```console
$ rake module:bump
```

### Push a module to a repository

Run rake. Ensure you are doing it in a clean working folder or the puppet module builder will package all the unnecessary files.

```console
$ rake module:push
```

#### Configuring to push a module to the Puppet Forge

Configure your credentials in `~/.puppetforge.yml`. Forge API keys may be created and revoked from a user's
profile on the [Forge website](https://forge.puppet.com/), where other profile details are managed.

```yaml
---
api_key: myAPIkey
```

Or set the equivalent environment variable in your shell

```bash
export BLACKSMITH_FORGE_API_KEY=myAPIkey
```


#### Configuring to push a module to a JFrog Artifactory

Configure your credentials in `~/.puppetforge.yml` or within the project's root directory in `./puppetforge.yml`

```yaml
---
url: https://artifactory.example.com
forge_type: artifactory
username: myuser
password: mypassword
```

Or set the equivalent environment variables in your shell

```bash
export BLACKSMITH_FORGE_URL=https://artifactory.example.com
export BLACKSMITH_FORGE_TYPE=artifactory
export BLACKSMITH_FORGE_USERNAME=myuser
export BLACKSMITH_FORGE_PASSWORD=mypassword
```

Alternatively, you can generate an API Key on the Artifactory profile page and us that in `puppetforge.yml`.

```yaml
---
url: https://artifactory.example.com
forge_type: artifactory
api_key: myAPIkey
````

Or via an environment variable:

```bash
export BLACKSMITH_FORGE_API_KEY=myAPIkey
```

# Customizing tasks

In your Rakefile:

```ruby
require 'puppet_blacksmith/rake_tasks'
Blacksmith::RakeTask.new do |t|
  t.tag_pattern = "v%s" # Use a custom pattern with git tag. %s is replaced with the version number.
  t.build = false # do not build the module nor push it to the Forge, just do the tagging [:clean, :tag, :bump_commit]
end
````

# GPG signed tags

In your Rakefile:

```ruby
require 'puppet_blacksmith/rake_tasks'
Blacksmith::RakeTask.new do |t|
  t.tag_message_pattern = "Version %s" # Signed tags must have a message
  t.tag_sign = true # enable GPG signing
end
```

# Testing blacksmith

```bash
bundle install
bundle exec rake
```

## Transfer Notice

This plugin was originally authored by [Carlos Sanchez](https://blog.csanchez.org/).
The maintainer preferred that Vox Pupuli take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute at https://github.com/voxpupuli/beaker-vmware

Previously: https://github.com/puppetlabs/beaker-vmware

## License

This gem is licensed under the Apache-2 license.

## Release information

To make a new release, please do:
* update the version in lib/puppet_blacksmith/version.rb
* Install gems with `bundle install --with release --path .vendor`
* generate the changelog with `bundle exec rake changelog`
* Check if the new version matches the closed issues/PRs in the changelog
* Create a PR with it
* After it got merged, push a tag. GitHub actions will do the actual release to rubygems and GitHub Packages
