puppet-blacksmith
=================

[![Build Status](https://travis-ci.org/voxpupuli/puppet-blacksmith.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-blacksmith)

Ruby Gem with several Puppet Module utilities

![I don't always release my Puppet modules, but when I do I push them directly to the Forge](https://raw.github.com/maestrodev/puppet-blacksmith/gh-pages/dos-equis.jpg)

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

Configure your credentials in `~/.puppetforge.yml`

```yaml
---
username: myuser
password: mypassword
```

Or set the equivalent environment variables in your shell

```bash
export BLACKSMITH_FORGE_USERNAME=myuser
export BLACKSMITH_FORGE_PASSWORD=mypassword
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

Alternatively to username and password, Artifactory supports using an API Key obtained from its front-end. This can be set in the `puppetforge.yml`

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

# Building blacksmith

```bash
bundle install
bundle exec rake
```

To cut a release: builds the gem, tags with git, pushes to rubygems and bumps the version number

```bash
bundle exec rake module:release
```
