require 'spec_helper'
require 'fileutils'
require 'webmock/rspec'

describe 'Blacksmith::Forge' do

  subject { Blacksmith::Forge.new(username, password, forge) }
  let(:username) { 'johndoe' }
  let(:password) { 'secret' }
  let(:forge) { "https://forgestagingapi.puppetlabs.com" }
  let(:module_name) { "test" }
  let(:version) { "1.0.0" }
  let(:module_name) { "maestrodev-test" }
  let(:spec_data) { File.join(File.dirname(__FILE__), '/../data') }
  let(:spec_module) { File.join(spec_data, module_name) }
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
        expect { foo = Blacksmith::Forge.new(nil, password, forge) }.to raise_error(/Could not find Puppet Forge credentials file '\/home\/mr\_puppet\/.puppetforge.yml'\s*Please create it\s*---\s*url: https:\/\/forgeapi.puppetlabs.com\s*username: myuser\s*password: mypassword/)
      end
    end

  end

  describe 'push', :credentials => true do
    let(:headers) { { 'User-Agent' => %r{^Blacksmith/#{Blacksmith::VERSION} Ruby/.* \(.*\)$} } }

    before do
      FileUtils.mkdir_p(target)

      # update version
      f = File.join(spec_module, "metadata.json")
      metadata = JSON.parse File.read(f)
      metadata['version'] = "1.0.#{Random.rand(9999999)}"
      File.open(File.join(target, "metadata.json"),"w") do |file|
        file.write(JSON.pretty_generate(metadata))
      end
      `cd #{target}/..; tar -czf #{module_name}.tar.gz #{module_name}`
    end

    context "when using username and password" do
      before do

        stub_request(:post, "#{forge}/oauth/token").with(
            :body => {
              "client_id"=>"b93eb708fd942cfc7b4ed71db6ce219b814954619dbe537ddfd208584e8cff8d",
              "client_secret"=>"216648059ad4afec3e4d77bd9e67817c095b2dcf94cdec18ac3d00584f863180",
              "grant_type"=>"password",
              "password"=>"secret",
              "username"=>"johndoe"
            },
            :headers => headers
          ).to_return(
            :status => 200,
            :body => {"access_token" => "e52f78b62e97cb8d8db6659a73aa522cca0f5c74d4714e0ed0bdd10000000000", "scope" =>""}.to_json,
            :headers => {})

        stub_request(:post, "#{forge}/v2/releases").with(
            :body => %r{Content-Disposition: form-data; name=\"file\"; filename=\"maestrodev-test.tar.gz\"\r\nContent-Type: application/gzip},
            :headers => headers.merge({'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer e52f78b62e97cb8d8db6659a73aa522cca0f5c74d4714e0ed0bdd10000000000', 'Content-Type'=>%r{multipart/form-data;}})
          ).to_return(:status => 200, :body => File.read(File.join(spec_data, "response.json")), :headers => {})

        subject.push!(module_name, package)
      end

      it "should push the module" do

      end
    end

  end
end

