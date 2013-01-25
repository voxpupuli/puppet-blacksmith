require 'puppet_blacksmith/rake_tasks'

describe 'rake tasks' do

  describe 'replace_version' do
    it "should replace the version" do
      original = <<-eos
name 'maestrodev-test'
version '1.0.0'

author 'maestrodev'
license 'Apache License, Version 2.0'
project_page 'http://github.com/maestrodev/puppet-blacksmith'
source 'http://github.com/maestrodev/puppet-blacksmith'
summary 'version "1"'
description "version '1'"
eos

      expected = <<-eos
name 'maestrodev-test'
version '1.0.1'

author 'maestrodev'
license 'Apache License, Version 2.0'
project_page 'http://github.com/maestrodev/puppet-blacksmith'
source 'http://github.com/maestrodev/puppet-blacksmith'
summary 'version "1"'
description "version '1'"
eos

      replace_version(original, "1.0.1").should eql(expected)
    end
  end

  describe 'increase_version' do
    it "should increase the version" do
      increase_version("1.0").should eql("1.1")
      increase_version("1.0.0").should eql("1.0.1")
      increase_version("1.0.1").should eql("1.0.2")
      expect { increase_version("1.0.12qwe") }.to raise_error
    end
  end

  describe 'modulefile' do
    it "should parse the modulefile" do
      m = modulefile("spec/data/Modulefile")
      m.version.should eql("1.0.0")
      m.username.should eql("maestrodev")
      m.name.should eql("test")
    end
  end
end
