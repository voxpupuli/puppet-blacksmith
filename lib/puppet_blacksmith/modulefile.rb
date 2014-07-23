# Avoid loading everything Puppet when we only need the module tool
# It causes trouble running it from jruby warbled jars
# module Puppet
#   def self.settings
#     {}
#   end
#   def self.[](param)
#   end
# end
# require 'puppet/error'
# require 'puppet/module_tool'
require 'puppet'
require 'puppet/module_tool'

Puppet[:confdir] = "."

module Blacksmith
  class Modulefile

    FILES = ["metadata.json", "Modulefile"]

    attr_reader :path

    def initialize(path = nil)
      @path = path.nil? ? FILES.find {|f| File.exists? f} : path
      raise Blacksmith::Error, "Unable to find any of #{FILES}" unless @path
      @modulefile = @path =~ /Modulefile$/
    end

    def metadata
      unless @metadata
        if @modulefile
          metadata = Puppet::ModuleTool::Metadata.new
          Puppet::ModuleTool::ModulefileReader.evaluate(metadata, path)
          @metadata = { 'name' => metadata.name, 'version' => metadata.version }
        else
          @metadata = JSON.parse(File.read(path))
        end
      end
      @metadata
    end

    def name
      metadata['name']
    end
    def version
      metadata['version']
    end

    def bump!
      new_version = increase_version(version)
      text = File.read(path)
      text = replace_version(text, new_version)
      File.open(path, "w") {|file| file.puts text}
      new_version
    end

    def replace_version(text, version)
      if @modulefile
        text.gsub(/\nversion[ ]+['"].*['"]/, "\nversion '#{version}'")
      else
        json = JSON.parse(text)
        json['version'] = version
        JSON.pretty_generate(json)
      end
    end

    def increase_version(version)
      v = Gem::Version.new("#{version}.0")
      raise Blacksmith::Error, "Unable to increase prerelease version #{version}" if v.prerelease?
      v.bump.to_s
    end
  end
end
