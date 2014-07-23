require 'spec_helper'

describe 'Blacksmith::Modulefile' do

  let(:path) { "spec/data/metadata.json" }

  subject { Blacksmith::Modulefile.new(path) }

  context "using metadata.json" do

    context 'when it is parsed' do
      it { expect(subject.version).to eql("1.0.0") }
      it { expect(subject.name).to eql("maestrodev-test") }
    end

    describe 'replace_version' do
      it "should replace the version in metadata" do

        expected = <<-eos
          {
            "operatingsystem_support": [
              {
                "operatingsystem": "CentOS",
                "operatingsystemrelease": [
                  "4",
                  "5",
                  "6"
                ]
              }
            ],
            "requirements": [
              {
                "name": "pe",
                "version_requirement": "3.2.x"
              },
              {
                "name": "puppet",
                "version_requirement": ">=2.7.20 <4.0.0"
              }
            ],
            "name": "maestrodev-test",
            "version": "1.0.1",
            "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
            "author": "maestrodev",
            "license": "Apache 2.0",
            "summary": "Puppet Module Standard Library",
            "description": "Standard Library for Puppet Modules",
            "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
            "dependencies": [
            ]
          }
        eos

        expect(JSON.parse(subject.replace_version(File.read(path), "1.0.1"))).to eql(JSON.parse(expected))
      end
    end

  end

  context "using a Modulefile" do

    let(:path) { "spec/data/Modulefile" }

    context 'when it is parsed' do
      it { expect(subject.version).to eql("1.0.0") }
      it { expect(subject.name).to eql("test") }
    end

    describe 'replace_version' do
      it "should replace the version in a Modulefile" do
        expected = <<-eos
name 'maestrodev-test'
version '1.0.1'

license 'Apache License, Version 2.0'
project_page 'http://github.com/maestrodev/puppet-blacksmith'
source 'http://github.com/maestrodev/puppet-blacksmith'
summary 'Testing Puppet module operations'
description 'Testing Puppet module operations'
eos

        expect(subject.replace_version(File.read(path), "1.0.1")).to eql(expected)
      end
    end

  end

  describe 'increase_version' do
    it { expect(subject.increase_version("1.0")).to eql("1.1") }
    it { expect(subject.increase_version("1.0.0")).to eql("1.0.1") }
    it { expect(subject.increase_version("1.0.1")).to eql("1.0.2") }
    it { expect { subject.increase_version("1.0.12qwe") }.to raise_error }
  end
end
