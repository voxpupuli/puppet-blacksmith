# Changelog

## [8.3.0](https://github.com/voxpupuli/puppet-blacksmith/tree/8.3.0) (2025-07-18)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v8.2.0...8.3.0)

**Implemented enhancements:**

- remove unused puppet testing dependency [\#141](https://github.com/voxpupuli/puppet-blacksmith/pull/141) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- cucumber: Allow 10.x [\#138](https://github.com/voxpupuli/puppet-blacksmith/pull/138) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v8.2.0](https://github.com/voxpupuli/puppet-blacksmith/tree/v8.2.0) (2025-06-27)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v8.1.0...v8.2.0)

**Merged pull requests:**

- Update base64 requirement from ~\> 0.2.0 to \>= 0.2, \< 0.4 [\#137](https://github.com/voxpupuli/puppet-blacksmith/pull/137) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v8.1.0](https://github.com/voxpupuli/puppet-blacksmith/tree/v8.1.0) (2025-01-20)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v8.0.0...v8.1.0)

**Implemented enhancements:**

- Add Ruby 3.4 support [\#132](https://github.com/voxpupuli/puppet-blacksmith/pull/132) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Update voxpupuli-rubocop requirement from ~\> 2.8.0 to ~\> 3.0.0 [\#131](https://github.com/voxpupuli/puppet-blacksmith/pull/131) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v8.0.0](https://github.com/voxpupuli/puppet-blacksmith/tree/v8.0.0) (2024-10-21)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v7.1.0...v8.0.0)

**Breaking changes:**

- puppet-modulebuilder: Switch to 2.x; use file allowlist when building modules [\#125](https://github.com/voxpupuli/puppet-blacksmith/pull/125) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Ruby 3.3 to CI [\#129](https://github.com/voxpupuli/puppet-blacksmith/pull/129) ([bastelfreak](https://github.com/bastelfreak))

## [v7.1.0](https://github.com/voxpupuli/puppet-blacksmith/tree/v7.1.0) (2024-10-21)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v7.0.0...v7.1.0)

**Implemented enhancements:**

- voxpupuli-rubocop: Switch to 2.8.0 [\#126](https://github.com/voxpupuli/puppet-blacksmith/pull/126) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Update cucumber requirement from ~\> 8.0 to ~\> 9.0 [\#123](https://github.com/voxpupuli/puppet-blacksmith/pull/123) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update voxpupuli-rubocop requirement from ~\> 1.2 to ~\> 2.0 [\#121](https://github.com/voxpupuli/puppet-blacksmith/pull/121) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v7.0.0](https://github.com/voxpupuli/puppet-blacksmith/tree/v7.0.0) (2023-05-09)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v6.1.1...v7.0.0)

**Breaking changes:**

- Remove oauth username/password login [\#119](https://github.com/voxpupuli/puppet-blacksmith/pull/119) ([bastelfreak](https://github.com/bastelfreak))
- Drop Ruby 2.4/2.5/2.6 support; Implement RuboCop [\#109](https://github.com/voxpupuli/puppet-blacksmith/pull/109) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Enable Tests on Ruby 3.1/3.2 [\#108](https://github.com/voxpupuli/puppet-blacksmith/pull/108) ([bastelfreak](https://github.com/bastelfreak))
- Switch from {Dir,File}.exists? to exist? [\#107](https://github.com/voxpupuli/puppet-blacksmith/pull/107) ([tuxmea](https://github.com/tuxmea))
- Update to API v3 [\#105](https://github.com/voxpupuli/puppet-blacksmith/pull/105) ([binford2k](https://github.com/binford2k))

**Closed issues:**

- Incompatible with ruby 3.2 \(and Puppet 8\) [\#106](https://github.com/voxpupuli/puppet-blacksmith/issues/106)
- Tag creation in wrong order [\#57](https://github.com/voxpupuli/puppet-blacksmith/issues/57)

**Merged pull requests:**

- GCG: Add faraday-retry dep [\#117](https://github.com/voxpupuli/puppet-blacksmith/pull/117) ([bastelfreak](https://github.com/bastelfreak))
- add dummy CI job we can depend on [\#116](https://github.com/voxpupuli/puppet-blacksmith/pull/116) ([bastelfreak](https://github.com/bastelfreak))
- CI: Build gems with strictness and verbosity & gemspec: Add dependency version constraints [\#115](https://github.com/voxpupuli/puppet-blacksmith/pull/115) ([bastelfreak](https://github.com/bastelfreak))
- puppet-modulebuilder: Switch to 1.x [\#114](https://github.com/voxpupuli/puppet-blacksmith/pull/114) ([bastelfreak](https://github.com/bastelfreak))

## [v6.1.1](https://github.com/voxpupuli/puppet-blacksmith/tree/v6.1.1) (2021-08-05)

[Full Changelog](https://github.com/voxpupuli/puppet-blacksmith/compare/v6.1.0...v6.1.1)

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
