require 'spec_helper'

describe 'Blacksmith::Modulefile' do

  subject { Blacksmith::Modulefile.new(path) }
  let(:path) { "spec/data/Modulefile" }

  context 'when modulefile is parsed' do
    it { subject.metadata.version.should eql("1.0.0") }
    it { subject.metadata.username.should eql("maestrodev") }
    it { subject.metadata.name.should eql("test") }
  end

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

      subject.replace_version(original, "1.0.1").should eql(expected)
    end
  end

  describe 'increase_version' do
    it { subject.increase_version("1.0").should eql("1.1") }
    it { subject.increase_version("1.0.0").should eql("1.0.1") }
    it { subject.increase_version("1.0.1").should eql("1.0.2") }
    it { expect { subject.increase_version("1.0.12qwe") }.to raise_error }
  end

end
