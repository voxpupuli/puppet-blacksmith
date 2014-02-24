source "https://rubygems.org"

gemspec

gem 'puppet', ENV['PUPPET_VERSION'] || '>=2.7.16'

if RUBY_VERSION < '1.9'
  gem 'nokogiri',  '~> 1.5.10'
  gem 'mime-types', '~> 1.0'
end
