if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
end

source :rubygems

gem 'rake'
gem 'rest-client'
gem 'puppet', '>=2.7.16'
gem 'puppetlabs_spec_helper', '>=0.3.0'
gem 'nokogiri'

group :test do
  gem 'cucumber'
  gem 'aruba'
  gem 'rspec', '>=2.7.0'
end
