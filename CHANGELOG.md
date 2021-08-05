# Changelog

## [6.1.1](https://github.com/voxpupuli/puppet-blacksmith/tree/6.1.1) (2021-08-05)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v6.1.0...6.1.1)

**Fixed bugs:**

- GHA: Set git user/email [\#100](https://github.com/voxpupuli/puppet-blacksmith/pull/100) ([bastelfreak](https://github.com/bastelfreak))
- Implement `clean` rake task [\#97](https://github.com/voxpupuli/puppet-blacksmith/pull/97) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- webmock: Allow 3.x [\#101](https://github.com/voxpupuli/puppet-blacksmith/pull/101) ([bastelfreak](https://github.com/bastelfreak))
- Implement GHA/GCG; Add badges to README.md [\#98](https://github.com/voxpupuli/puppet-blacksmith/pull/98) ([bastelfreak](https://github.com/bastelfreak))

## [v6.1.0](https://github.com/voxpupuli/puppet-blacksmith/tree/v6.1.0) (2020-11-18)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v6.0.1...v6.1.0)

**Merged pull requests:**

- Use puppet-modulebuilder ~\> 0.2 [\#94](https://github.com/voxpupuli/puppet-blacksmith/pull/94) ([ekohl](https://github.com/ekohl))
- Support API keys for the Puppet Forge [\#93](https://github.com/voxpupuli/puppet-blacksmith/pull/93) ([ekohl](https://github.com/ekohl))
- Add license to gemspec [\#91](https://github.com/voxpupuli/puppet-blacksmith/pull/91) ([timhughes](https://github.com/timhughes))

## [v6.0.1](https://github.com/voxpupuli/puppet-blacksmith/tree/v6.0.1) (2020-10-06)

* Add support for Puppet Forge API keys
* Add the full license text
* Require puppet-modulebuilder ~> 0.2

## 6.0.1

* Drop old ruby code
  * We had some code for Ruby 2.0 in the Gemfile. Since we require Ruby 2.4, we can drop the old code
* Forge upload should always use namespace

There is an author field in metadata.json, but `pdk build` always uses
the module's namespace when building the tarball. Therefore, Blacksmith
should do the same and not even use the author field.

## 6.0.0

This module moves from [puppetlabs_spec_helper](https://github.com/puppetlabs/puppetlabs_spec_helper)'s `build` rake task to its own `module:build` task which uses [puppet-modulebuilder](https://github.com/puppetlabs/puppet-modulebuilder). This has the benefit that it no longer needs the Puppet face (Puppet < 6) or the PDK (Puppet >= 6) and becomes standalone.

* Use puppet-modulebuilder to build modules

## 5.1.0

* Enable Artifactory access via API key. This provides an additional authentication mechanism besides a password
* Remove outdated variable reference. This fixes a regression in Artifactory upload exception handling

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
