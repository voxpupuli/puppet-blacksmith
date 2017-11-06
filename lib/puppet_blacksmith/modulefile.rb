require 'puppet_blacksmith/version_helper'

module Blacksmith
  class Modulefile

    FILES = ["metadata.json"]

    attr_reader :path

    def initialize(path = nil)
      @path = path.nil? ? FILES.find {|f| File.exists? f} : path
      raise Blacksmith::Error, "Unable to find any of #{FILES}" unless @path
    end

    def metadata
      @metadata = JSON.parse(File.read(path)) unless @metadata
      @metadata
    end

    # name in metadata.json is author-modulename
    def name
      metadata['name'].split('-',2)[1]
    end
    def author
      metadata['author'] || metadata['name'].split('-',2)[0]
    end
    def version
      metadata['version']
    end

    def bump_to_version!(new_version)
      text = File.read(path)
      text = replace_version(text, new_version)
      File.open(path,"w") { |file| file.puts text }
      new_version
    end

    def bump!(level = :patch)
      new_version = increase_version(version, level)
      bump_to_version!(new_version)
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
      json = JSON.parse(text)
      json['version'] = version
      JSON.pretty_generate(json)
    end

    def increase_version(version, level = :patch)
      v = VersionHelper::Version.new(version)
      v.send("#{level}!").to_s
    end

    def replace_dependency_version(text, module_name, version)
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
