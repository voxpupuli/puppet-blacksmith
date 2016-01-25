require 'rest-client'
require 'json'
require 'yaml'

module Blacksmith
  class Forge

    PUPPETLABS_FORGE = "https://forgeapi.puppetlabs.com"
    CREDENTIALS_FILE_HOME = "~/.puppetforge.yml"
    CREDENTIALS_FILE_PROJECT = '.puppetforge.yml'
    DEFAULT_CREDENTIALS = { 'url' => PUPPETLABS_FORGE }
    HEADERS = { 'User-Agent' => "Blacksmith/#{Blacksmith::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}; #{RUBY_PLATFORM})" }

    attr_accessor :username, :password, :url, :client_id, :client_secret

    def initialize(username = nil, password = nil, url = nil)
      self.username = username
      self.password = password
      RestClient.proxy = ENV['http_proxy']
      load_credentials
      load_client_credentials_from_file
      self.url = url unless url.nil?
      if self.url =~ %r{http(s)?://forge.puppetlabs.com}
        puts "Ignoring url entry in .puppetforge.yml: must point to the api server at #{PUPPETLABS_FORGE}, not the Forge webpage"
        self.url = PUPPETLABS_FORGE
      end
    end

    def push!(name, package = nil)
      unless package
        regex = /^#{username}-#{name}-.*\.tar\.gz$/
        pkg = File.expand_path("pkg")
        f = Dir.new(pkg).select{|f| f.match(regex)}.last
        raise Errno::ENOENT, "File not found in #{pkg} with regex #{regex}" if f.nil?
        package = File.join(pkg, f)
      end
      raise Errno::ENOENT, "File does not exist: #{package}" unless File.exists?(package)

      # login to the puppet forge
      begin
        response = RestClient.post("#{url}/oauth/token", {
          'client_id' => client_id,
          'client_secret' => client_secret,
          'username' => username,
          'password' => password,
          'grant_type' => 'password'
        }, HEADERS)
      rescue RestClient::Exception => e
        raise Blacksmith::Error, "Error login to the forge #{url} as #{username} [#{e.message}]: #{e.response}"
      end
      login_data = JSON.parse(response)
      access_token = login_data['access_token']

      # upload the file
      begin
        response = RestClient.post("#{url}/v2/releases",
          {:file => File.new(package, 'rb')},
          HEADERS.merge({'Authorization' => "Bearer #{access_token}"}))
      rescue RestClient::Exception => e
        raise Blacksmith::Error, "Error uploading #{package} to the forge #{url} [#{e.message}]: #{e.response}"
      end
    end

    private

    def load_credentials
      file_credentials = load_credentials_from_file
      env_credentials = load_credentials_from_env

      credentials = DEFAULT_CREDENTIALS.merge file_credentials
      credentials = credentials.merge env_credentials

      self.username = credentials['username'] if credentials['username']
      self.password = credentials['password'] if credentials['password']
      if credentials['forge']
        # deprecated
        puts "'forge' entry is deprecated in .puppetforge.yml, use 'url'"
        self.url = credentials['forge']
      end
      self.url = credentials['url'] if credentials['url']

      unless self.username && self.password
        raise Blacksmith::Error, <<-eos
Could not find Puppet Forge credentials!

Please set the environment variables
BLACKSMITH_FORGE_URL
BLACKSMITH_FORGE_USERNAME
BLACKSMITH_FORGE_PASSWORD

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

      return credentials
    end

    def load_client_credentials_from_file
      credentials_file = File.expand_path(File.join(__FILE__, "..", "credentials.yml"))
      credentials = YAML.load_file(credentials_file)
      self.client_id = credentials['client_id']
      self.client_secret = credentials['client_secret']
    end
  end

end
