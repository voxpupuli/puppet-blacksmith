require 'spec_helper'
require 'fileutils'

describe 'Blacksmith::Forge' do

  subject { Blacksmith::Forge.new(username, password, forge) }
  let(:username) { nil }
  let(:password) { 'secret' }
  let(:forge) { "https://forgestagingapi.puppetlabs.com" }
  let(:module_name) { "test" }
  let(:version) { "1.0.0" }
  let(:module_name) { "maestrodev-test" }
  let(:spec_data) { File.join(File.dirname(__FILE__), '/../data', module_name) }
  let(:target) { File.expand_path(File.join(__FILE__, "../../..", "pkg", module_name)) }
  let(:package) { "#{target}.tar.gz" }

  describe 'missing credentials file' do
    before do
      allow(File).to receive(:expand_path) { '/home/mr_puppet/.puppetforge.yml' }
    end

    context "when the credentials file is missing" do
      before do

      end

      it "should raise an error" do
        expect { foo = Blacksmith::Forge.new(nil, password, forge) }.to raise_error(/Could not find Puppet Forge credentials file '\/home\/mr\_puppet\/.puppetforge.yml'\s*Please create it\s*---\s*url: https:\/\/forge.puppetlabs.com\s*username: myuser\s*password: mypassword/)
      end
    end

  end

  describe 'push' do

    before do
      FileUtils.mkdir_p(target)

      # update version
      f = File.join(spec_data, "metadata.json")
      metadata = JSON.parse File.read(f)
      metadata['version'] = "1.0.#{Random.rand(9999999)}"
      File.open(File.join(target, "metadata.json"),"w") do |file|
        file.write(JSON.pretty_generate(metadata))
      end
      `cd #{target}/..; tar -czf #{module_name}.tar.gz #{module_name}`
    end

    context "when using username and password" do
      before do
        subject.push!(module_name, package)
      end

      it "should push the module" do

      end
    end

  end
end

