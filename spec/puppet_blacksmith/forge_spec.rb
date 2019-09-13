require 'spec_helper'
require_relative 'forge_shared'
require 'fileutils'
require 'webmock/rspec'

describe 'Blacksmith::Forge' do
  include_context 'forge'

  describe 'resolving credentials' do
    before do
      allow(Dir).to receive(:pwd) { '/home/mr_puppet/puppet-some-module' }
      allow(File).to receive(:expand_path).with('~/.puppetforge.yml') { '/home/mr_puppet/.puppetforge.yml' }
      allow(File).to receive(:expand_path).with(/credentials.yml/) { '/home/mr_puppet/puppet-blacksmith/credentials.yml' }
      allow(YAML).to receive(:load_file).with('/home/mr_puppet/puppet-blacksmith/credentials.yml') { {
          "client_id" => "b93eb708fd942cfc7b4ed71db6ce219b814954619dbe537ddfd208584e8cff8d",
          "client_secret" => "216648059ad4afec3e4d77bd9e67817c095b2dcf94cdec18ac3d00584f863180",
      } }
    end

    it 'prefers env vars to file values' do
      stubbed_forge_password = 'asdf1234'

      allow(File).to receive(:exists?).
                      with('/home/mr_puppet/puppet-some-module/.puppetforge.yml').
                      and_return(false)
      allow(File).to receive(:exists?).
                      with('/home/mr_puppet/.puppetforge.yml').
                      and_return(true)
      allow(YAML).to receive(:load_file).
                      with('/home/mr_puppet/.puppetforge.yml').
                      and_return({'username' => username,
                                  'password' => password})
      allow(ENV).to receive(:[]).
                      with(any_args)
      allow(ENV).to receive(:[]).
                      with('BLACKSMITH_FORGE_PASSWORD').
                      and_return(stubbed_forge_password)

      forge = Blacksmith::Forge.new()

      expect(forge.url).to eq(Blacksmith::Forge::PUPPETLABS_FORGE)
      expect(forge.password).to eq(stubbed_forge_password)
      expect(forge.username).to eq(username)
    end

    context 'when the credentials values are unset' do
      it "should raise an error" do
        expect { foo = Blacksmith::Forge.new(nil, password, forge) }.to raise_error(/Could not find Puppet Forge credentials/)
      end
    end

    it 'loads credentials from home dir' do
      allow(File).to receive(:exists?).with('/home/mr_puppet/puppet-some-module/.puppetforge.yml') { false }
      allow(File).to receive(:exists?).with('/home/mr_puppet/.puppetforge.yml') { true }
      allow(YAML).to receive(:load_file).with('/home/mr_puppet/.puppetforge.yml') { {'username'=> 'puppet-user'} }

      subject = Blacksmith::Forge.new(nil, password, forge)
      expect(subject.username).to eq('puppet-user')
    end

    it 'loads credentials from project dir' do
      allow(File).to receive(:exists?).with('/home/mr_puppet/puppet-some-module/.puppetforge.yml') { true }
      allow(File).to receive(:exists?).with('/home/mr_puppet/.puppetforge.yml') { true }
      allow(YAML).to receive(:load_file).with('/home/mr_puppet/puppet-some-module/.puppetforge.yml') { {'username'=> 'puppet-other-user'} }

      subject = Blacksmith::Forge.new(nil, password, forge)
      expect(subject.username).to eq('puppet-other-user')
    end

  end

  describe 'push' do
    let(:login_body) {{
      "client_id"=>"b93eb708fd942cfc7b4ed71db6ce219b814954619dbe537ddfd208584e8cff8d",
      "client_secret"=>"216648059ad4afec3e4d77bd9e67817c095b2dcf94cdec18ac3d00584f863180",
      "grant_type"=>"password",
      "password"=>"secret",
      "username"=>"johndoe"
    }}

    before { create_tarball }

    context "when using username and password" do
      before do
        stub_request(:post, "#{forge}/oauth/token").with(
            :body => login_body,
            :headers => headers
          ).to_return(
            :status => 200,
            :body => {"access_token" => "e52f78b62e97cb8d8db6659a73aa522cca0f5c74d4714e0ed0bdd10000000000", "scope" =>""}.to_json,
            :headers => {})

        stub_request(:post, "#{forge}/v2/releases").with(
            :headers => headers.merge({'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer e52f78b62e97cb8d8db6659a73aa522cca0f5c74d4714e0ed0bdd10000000000', 'Content-Type'=>%r{\Amultipart/form-data;}})
          ) { |request |
            request.body =~ %r{Content-Disposition: form-data; name=\"file\"; filename=\"maestrodev-test.tar.gz\"\r\nContent-Type: application/gzip}
          }.to_return(:status => 200, :body => File.read(File.join(spec_data, "response.json")), :headers => {})

      end

      include_examples 'forge_push'
    end

    context "when using bad credentials" do
      before do
        stub_request(:post, "#{forge}/oauth/token").with(
            :body => login_body,
            :headers => headers
          ).to_return(
            :status => 400,
            :body => {"error"=>"invalid_grant","error_description"=>"Username/password do not match"}.to_json,
            :headers => {})
      end

      it "should push the module" do
        expect { subject.push!(module_name, package) }.to raise_error(Blacksmith::Error, "Error login to the forge #{forge} as #{username} [400 Bad Request]: {\"error\":\"invalid_grant\",\"error_description\":\"Username/password do not match\"}")
      end

    end
  end
end

