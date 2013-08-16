require 'rest-client'
require 'nokogiri'

module Blacksmith
  class Forge

    PUPPETLABS_FORGE = "https://forge.puppetlabs.com"

    attr_accessor :username, :password
    attr_writer :url

    def initialize(username = nil, password = nil, url = nil)
      self.username = username
      self.password = password
      self.url = url
      RestClient.proxy = ENV['http_proxy']
      load_credentials_from_file if username.nil?
    end

    def url
      @url || PUPPETLABS_FORGE
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
      response = RestClient.post(
        "#{url}/login",
        {'username' => username, 'password' => password}){
          |response, request, result, &block|
          if [301, 302, 307].include? response.code
            response # no need to follow redirects
          else
            response.return!(request, result, &block)
          end
      }
      raise Blacksmith::Error, "Failed to login to Puppet Forge: cookies not set correctly" unless response.cookies['auth']

      page = Nokogiri::HTML(response.body)
      errors = page.css('.failure')
      raise Blacksmith::Error, "Error uploading module #{package} to Puppet Forge #{username}/#{name}:#{errors.text}" unless errors.empty?

      # upload the file
      response = RestClient.post("#{url}/#{username}/#{name}/upload",
        {:tarball => File.new(package, 'rb')},
        {:cookies => response.cookies}){
          |response, request, result, &block|
          if [301, 302, 307].include? response.code
            response # no need to follow redirects
          else
            response.return!(request, result, &block)
          end
      }
      page = Nokogiri::HTML(response.body)
      errors = page.css('.errors')
      raise Blacksmith::Error, "Error uploading module #{package} to Puppet Forge #{username}/#{name}:#{errors.text}" unless errors.empty?
    end

    private

    def load_credentials_from_file
      credentials_file = File.expand_path("~/.puppetforge.yml")
      unless File.exists?(credentials_file)
        raise Blacksmith::Error, <<-eos
Could not find Puppet Forge credentials file '#{credentials_file}'
Please create it
--- 
forge: https://forge.puppetlabs.com
username: myuser
password: mypassword
    eos
      end
      credentials = YAML.load_file(credentials_file)
      self.username = credentials['username']
      self.password = credentials['password']
      if credentials['forge']
        # deprecated
        puts "'forge' entry is deprecated in .puppetforge.yml, use 'url'"
        self.url = credentials['forge']
      end
      self.url = credentials['url'] if credentials['url']
    end
  end
end
