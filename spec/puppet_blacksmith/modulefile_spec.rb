require 'spec_helper'

describe 'Blacksmith::Modulefile' do

  let(:path) { "spec/data/metadata.json" }

  subject { Blacksmith::Modulefile.new(path) }

  shared_examples_for :metadata do
    it { expect(subject.version).to eql("1.0.0") }
    it { expect(subject.name).to eql("test") }
  end

  context "using metadata.json" do

    it_behaves_like :metadata

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
                {
                    "name": "puppetlabs-stdlib",
                    "version_requirement": ">= 3.0.0"
                }
            ]
          }
        eos

        expect(JSON.parse(subject.replace_version(File.read(path), "1.0.1"))).to eql(JSON.parse(expected))
      end
    end

    describe 'replace_dependency_version' do
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
            "version": "1.0.0",
            "source": "git://github.com/puppetlabs/puppetlabs-stdlib",
            "author": "maestrodev",
            "license": "Apache 2.0",
            "summary": "Puppet Module Standard Library",
            "description": "Standard Library for Puppet Modules",
            "project_page": "https://github.com/puppetlabs/puppetlabs-stdlib",
            "dependencies": [
                {
                    "name": "puppetlabs-stdlib",
                    "version_requirement": ">= 4.0.0"
                }
            ]
          }
        eos

        expect(JSON.parse(subject.replace_dependency_version(File.read(path), 'puppetlabs-stdlib', '>= 4.0.0'))).to eql(JSON.parse(expected))
      end
    end

  end

  context "using a Modulefile" do

    let(:path) { "spec/data/Modulefile" }

    it_behaves_like :metadata

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
dependency 'puppetlabs/stdlib', '>= 3.0.0'
eos

        expect(subject.replace_version(File.read(path), "1.0.1")).to eql(expected)
      end
    end

    describe 'replace_dependency_version' do
      it "should replace the dependency version in a Modulefile" do
        expected = <<-eos
name 'maestrodev-test'
version '1.0.0'

license 'Apache License, Version 2.0'
project_page 'http://github.com/maestrodev/puppet-blacksmith'
source 'http://github.com/maestrodev/puppet-blacksmith'
summary 'Testing Puppet module operations'
description 'Testing Puppet module operations'
dependency 'puppetlabs/stdlib', '>= 4.0.0'
eos

        expect(subject.replace_dependency_version(File.read(path), 'puppetlabs-stdlib', '>= 4.0.0')).to eql(expected)
      end
    end
  end

  describe 'increase_version' do
    it { expect(subject.increase_version("1.0.0")).to eql("1.0.1") }
    it { expect(subject.increase_version("1.0.1")).to eql("1.0.2") }
    it { expect { subject.increase_version("1.0") }.to raise_error }
    it { expect { subject.increase_version("1.0.12qwe") }.to raise_error }
  end

  describe 'bump patch version' do
    it { expect(subject.increase_version("1.0.0", :patch)).to eql("1.0.1") }
    it { expect(subject.increase_version("1.1.0", :patch)).to eql("1.1.1") }
    it { expect(subject.increase_version("1.1.1", :patch)).to eql("1.1.2") }
  end

  describe 'bump minor version' do
    it { expect(subject.increase_version("1.0.0", :minor)).to eql("1.1.0") }
    it { expect(subject.increase_version("1.1.0", :minor)).to eql("1.2.0") }
    it { expect(subject.increase_version("1.1.1", :minor)).to eql("1.2.0") }
  end

  describe 'bump major version' do
    it { expect(subject.increase_version("1.0.0", :major)).to eql("2.0.0") }
    it { expect(subject.increase_version("1.1.0", :major)).to eql("2.0.0") }
    it { expect(subject.increase_version("1.1.1", :major)).to eql("2.0.0") }
  end
end
