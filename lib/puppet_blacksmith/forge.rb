require 'rest-client'
require 'json'
require 'yaml'
require 'base64'

module Blacksmith
  class Forge

    PUPPETLABS_FORGE = "https://forgeapi.puppetlabs.com"
    CREDENTIALS_FILE_HOME = "~/.puppetforge.yml"
    CREDENTIALS_FILE_PROJECT = '.puppetforge.yml'
    FORGE_TYPE_PUPPET = 'puppet'
    FORGE_TYPE_ARTIFACTORY = 'artifactory'
    SUPPORTED_FORGE_TYPES = [FORGE_TYPE_PUPPET, FORGE_TYPE_ARTIFACTORY]
    DEFAULT_CREDENTIALS = { 'url' => PUPPETLABS_FORGE, 'forge_type' => FORGE_TYPE_PUPPET }
    HEADERS = { 'User-Agent' => "Blacksmith/#{Blacksmith::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}; #{RUBY_PLATFORM})" }

    attr_accessor :username, :password, :url, :forge_type, :token, :api_key

    def initialize(username = nil, password = nil, url = nil, forge_type = nil, token = nil, api_key = nil)
      self.username = username
      self.password = password
      self.token = token
      self.api_key = api_key
      RestClient.proxy = ENV['http_proxy']
      load_credentials
      self.url = url unless url.nil?
      if self.url =~ %r{http(s)?://forge.puppetlabs.com}
        puts "Ignoring url entry in .puppetforge.yml: must point to the api server at #{PUPPETLABS_FORGE}, not the Forge webpage"
        self.url = PUPPETLABS_FORGE
      end
      self.forge_type = forge_type unless forge_type.nil?
      raise Blacksmith::Error, "Unsupported forge type: #{self.forge_type}" unless SUPPORTED_FORGE_TYPES.include?(self.forge_type)
    end

    def push!(name, package = nil, author = nil, version = nil)
      user = author || username
      unless package
        v = version ? Regexp.escape(version) : '.*'
        regex = /^#{user}-#{name}-#{v}\.tar\.gz$/
        pkg = File.expand_path("pkg")
        f = Dir.new(pkg).select{|fn| fn.match(regex)}.last
        raise Errno::ENOENT, "File not found in #{pkg} with regex #{regex}" if f.nil?
        package = File.join(pkg, f)
      end
      raise Errno::ENOENT, "File does not exist: #{package}" unless File.exists?(package)

      upload(user, name, package)
    end

    private

    def upload(author, name, file)
      url = http_url(author, name, file)
      case forge_type
      when FORGE_TYPE_ARTIFACTORY
        RestClient::Request.execute(:method => :put, :url => url, :payload => File.new(file, 'rb'), :headers => http_headers)
      else
        RestClient::Request.execute(:method => :post, :url => url, :payload => {:file => File.new(file, 'rb')}, :headers => http_headers)
      end
    rescue RestClient::Exception => e
      raise Blacksmith::Error, "Error uploading #{name} to the forge #{url} [#{e.message}]: #{e.response}"
    end

    def http_url(author, name, file)
      case forge_type
      when FORGE_TYPE_ARTIFACTORY
        "#{url}/#{author}/#{name}/#{File.basename(file)}"
      else
        "#{url}/v2/releases"
      end
    end

    def http_headers
      case forge_type
      when FORGE_TYPE_ARTIFACTORY
        if api_key
          HEADERS.merge({'X-JFrog-Art-Api' => api_key})
        elsif token
          HEADERS.merge({'Authorization' => "Bearer #{token}"})
        else
          HEADERS.merge({'Authorization' => "Basic " + Base64.strict_encode64("#{username}:#{password}")})
        end
      else
        HEADERS.merge({'Authorization' => "Bearer #{api_key || token}"})
      end
    end

    def load_credentials
      file_credentials = load_credentials_from_file
      env_credentials = load_credentials_from_env

      credentials = DEFAULT_CREDENTIALS.merge file_credentials
      credentials = credentials.merge env_credentials

      self.username = credentials['username'] if credentials['username']
      self.password = credentials['password'] if credentials['password']
      self.token = credentials['token'] if credentials['token']
      self.api_key = credentials['api_key'] if credentials['api_key']
      if credentials['forge']
        # deprecated
        puts "'forge' entry is deprecated in .puppetforge.yml, use 'url'"
        self.url = credentials['forge']
      end
      self.url = credentials['url'] if credentials['url']
      self.forge_type = credentials['forge_type'] if credentials['forge_type']

      unless (self.username && self.password) || self.token || self.api_key
        raise Blacksmith::Error, <<-eos
Could not find Puppet Forge credentials!

Please set the environment variables
BLACKSMITH_FORGE_URL
BLACKSMITH_FORGE_TYPE
BLACKSMITH_FORGE_USERNAME
BLACKSMITH_FORGE_PASSWORD
BLACKSMITH_FORGE_TOKEN
BLACKSMITH_FORGE_API_KEY

or create the file '#{CREDENTIALS_FILE_PROJECT}' or '#{CREDENTIALS_FILE_HOME}'
with content similiar to:

---
url: https://forgeapi.puppetlabs.com
username: myuser
password: mypassword

    eos
      end
    end

    def load_credentials_from_file
      credentials_file = [
          File.join(Dir.pwd, CREDENTIALS_FILE_PROJECT),
          File.expand_path(CREDENTIALS_FILE_HOME)
      ]
                             .select { |file| File.exists?(file) }
                             .first

      if credentials_file
        credentials = YAML.load_file(credentials_file)
      else
        credentials = Hash.new
      end

      return credentials
    end

    def load_credentials_from_env
      credentials = Hash.new

      if ENV['BLACKSMITH_FORGE_USERNAME']
        credentials['username'] = ENV['BLACKSMITH_FORGE_USERNAME']
      end

      if ENV['BLACKSMITH_FORGE_PASSWORD']
        credentials['password'] = ENV['BLACKSMITH_FORGE_PASSWORD']
      end

      if ENV['BLACKSMITH_FORGE_URL']
        credentials['url'] = ENV['BLACKSMITH_FORGE_URL']
      end

      if ENV['BLACKSMITH_FORGE_TYPE']
        credentials['forge_type'] = ENV['BLACKSMITH_FORGE_TYPE']
      end

      if ENV['BLACKSMITH_FORGE_TOKEN']
        credentials['token'] = ENV['BLACKSMITH_FORGE_TOKEN']
      end

      if ENV['BLACKSMITH_FORGE_API_KEY']
        credentials['api_key'] = ENV['BLACKSMITH_FORGE_API_KEY']
      end

      return credentials
    end

  end

end
