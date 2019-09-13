# Changelog

## 5.0.0

Note: The gemspec got updated to require at least Ruby 2.4 or newer. Older
versions are end of life and unsupported.

* Add note about clearing the rake task cache
* Add support for Artifactory uploads
* Update the maximum allows puppet versions
* Update description for module:release task
* Factor out uploading to separate functions
* Handle RC versions while patching
* Improve testing code

## 4.1.2

* Fix an incorrect checksum on rubygems

## 4.1.1

* Expose `tag_sign` option in the RakeTask

## 4.1.0

* Allow creating signed tags

## 4.0.1

This version is a fixup release since the 4.0.0 release broke the CI of a user which was still using Ruby 1.9.3.

* Require ruby >= 2.0.0 in the gemspec

## 4.0.0

This version drops Modulefile support. Upstream Puppet has removed the support from the code and we used that. It means we no longer use the Puppet gem which greatly reduces the profile of the module.

* Add has_tag? and has_version_tag? methods
* Make exec_git a private method
* Support Ruby 2.2 - 2.4
* Rip out Modulefile support
* Allow using newer rest-client and webmock versions
* Handle spaces in git paths
* Allow creating annotated git commits
* Make commit message configurable
* Fix rake module release order
* Drop ruby 1.9 support

## 3.4.0

* Pin rest-client and webmock for ruby 1.9 support
* Add 'version', 'version:next' and 'version:next:[patch|major|minor]'
* Allow loading forge credentials from project dir
* Add bump_commit commands for patch, minor, major and full
* Allow setting credentials via env vars
* Add bump:full rake task

## 3.3.1

* `bump:*` runs twice if task is defined in `Rakefile`

## 3.3.0

* Allow releasing without building nor pushing to the forge, just git tagging [:clean, :tag, :bump_commit], using `build = false`

## 3.2.0

* Enable bumping semantic version elements with `module:bump:` plus `patch`, `minor`, `major`

## 3.1.0

* Added feature to bump dependencies `module:dependency[modulename, version]`
* Add support for custom tag patterns

## 3.0.3

* [Issue #11](https://github.com/maestrodev/puppet-blacksmith/issues/11) Require json and yaml in forge.rb
* [Issue #10](https://github.com/maestrodev/puppet-blacksmith/issues/10) Added support to git commit the version

## 3.0.2

* [Issue #9](https://github.com/maestrodev/puppet-blacksmith/issues/9) Better error messages when pushing to the Forge fails

## 3.0.1

* Fix uninitialized constant Blacksmith::VERSION

## 3.0.0

* Use API to upload to the Forge instead of parsing the webpage
* Use a custom Blacksmith `User-Agent`

## 2.3.1

* [Issue #7](https://github.com/maestrodev/puppet-blacksmith/issues/7) `module:bump_commit` fails if `Modulefile` does not exist

## 2.2.0

* [Issue #6](https://github.com/maestrodev/puppet-blacksmith/issues/6) Add support for `metadata.json`

## 2.1.0

* Support Puppet 3.5+

## 2.0.0

* Reworked to be a library plus rake tasks so it an be reused
* `.puppetforge.yml` `forge` entry is deprecated, use `url`
