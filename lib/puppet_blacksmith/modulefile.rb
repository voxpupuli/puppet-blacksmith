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

    attr_reader :path

    def initialize(path = "Modulefile")
      @path = path
    end

    def metadata
      unless @metadata
        metadata = Puppet::ModuleTool::Metadata.new
        Puppet::ModuleTool::ModulefileReader.evaluate(metadata, path)
        @metadata = metadata
      end
      @metadata
    end

    def name
      metadata.name
    end
    def version
      metadata.version
    end

    def bump!
      new_version = increase_version(version)
      text = File.read(path)
      text = replace_version(text, new_version)
      File.open(path, "w") {|file| file.puts text}
      new_version
    end

    def replace_version(text, version)
      text.gsub(/\nversion[ ]+['"].*['"]/, "\nversion '#{version}'")
    end

    def increase_version(version)
      v = Gem::Version.new("#{version}.0")
      raise Blacksmith::Error, "Unable to increase prerelease version #{version}" if v.prerelease?
      v.bump.to_s
    end
  end
end
