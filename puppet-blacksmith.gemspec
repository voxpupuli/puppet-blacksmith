lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_blacksmith/version'

Gem::Specification.new do |s|
  s.name = 'puppet-blacksmith'
  s.version = Blacksmith::VERSION

  s.authors = ['MaestroDev', 'Vox Pupuli']
  s.summary = 'Tasks to manage Puppet module builds'
  s.description = 'Puppet module tools for development and Puppet Forge management'
  s.email = ['voxpupuli@groups.io']
  s.homepage = 'http://github.com/voxpupuli/puppet-blacksmith'
  s.license = 'Apache-2.0'
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.7.0'

  s.add_runtime_dependency 'puppet-modulebuilder', '~> 1.0'
  s.add_runtime_dependency 'rest-client', '~>2.0'
  s.add_development_dependency 'aruba', '~> 2.1'
  s.add_development_dependency 'cucumber', '~> 9.0'
  s.add_development_dependency 'puppet', '>= 7.24', '< 9'
  s.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  s.add_development_dependency 'rspec', '~> 3.12'
  s.add_development_dependency 'voxpupuli-rubocop', '~> 2.8.0'
  s.add_development_dependency 'webmock', '>= 2.0', '< 4'

  s.files = Dir.glob('lib/**/*') + %w[LICENSE]
end
