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
require 'puppet_blacksmith/version_helper'

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
          @metadata = { 'name' => metadata.name, 'version' => metadata.version, 'author' => metadata.author }
        else
          @metadata = JSON.parse(File.read(path))
        end
      end
      @metadata
    end

    # name in metadata.json is author-modulename
    def name
      @modulefile ? metadata['name'] : metadata['name'].split('-',2)[1]
    end
    def author
      metadata['author'] || metadata['name'].split('-',2)[0]
    end
    def version
      metadata['version']
    end

    def bump!(level = :patch)
      new_version = increase_version(version, level)
      text = File.read(path)
      text = replace_version(text, new_version)
      File.open(path, "w") {|file| file.puts text}
      new_version
    end

    [:major, :minor, :patch, :full].each do |level|
      define_method("bump_#{level}!") { bump!(level) }
    end

    def bump_dep!(module_name, version)
      text = File.read(path)
      text = replace_dependency_version(text, module_name, version)
      File.open(path, "w") {|file| file.puts text}
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

    def increase_version(version, level = :patch)
      v = VersionHelper::Version.new(version)
      v.send("#{level}!").to_s
    end

    def replace_dependency_version(text, module_name, version)
      if @modulefile
        # example: dependency 'puppetlabs/stdlib', '>= 2.3.0'
        module_name = module_name.sub(/^([^\/-]+)-/, '\1/')
        text.gsub(/\ndependency[ ]+['"].*#{module_name}['"],([ ]+['"].*['"]|)/, "\ndependency '#{module_name}', '#{version}'")
      else
        module_name = module_name.sub(/\//, '-')
        json = JSON.parse(text)
        new_dep_list = []
        json['dependencies'].each do |dep|
          dep['version_requirement'] = version if dep['name'] == module_name
          new_dep_list << dep
        end
        json['dependencies'] = new_dep_list
        JSON.pretty_generate(json)
      end
    end
  end
end
