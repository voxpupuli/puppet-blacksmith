require 'spec_helper'
require_relative 'forge_shared'
require 'fileutils'
require 'webmock/rspec'

describe 'Blacksmith::Forge' do
  include_context 'forge'

  describe 'resolving credentials' do
    before do
      allow(Dir).to receive(:pwd).and_return('/home/mr_puppet/puppet-some-module')
      allow(File).to receive(:expand_path).with('~/.puppetforge.yml').and_return('/home/mr_puppet/.puppetforge.yml')
    end

    it 'prefers env vars to file values' do
      stubbed_forge_password = 'asdf1234'

      allow(File).to receive(:exist?)
        .with('/home/mr_puppet/puppet-some-module/.puppetforge.yml')
        .and_return(false)
      allow(File).to receive(:exist?)
        .with('/home/mr_puppet/.puppetforge.yml')
        .and_return(true)
      allow(YAML).to receive(:load_file)
        .with('/home/mr_puppet/.puppetforge.yml')
        .and_return({ 'username' => username,
                      'password' => password, })
      allow(ENV).to receive(:[])
        .with(any_args)
      allow(ENV).to receive(:[])
        .with('BLACKSMITH_FORGE_PASSWORD')
        .and_return(stubbed_forge_password)

      forge = Blacksmith::Forge.new

      expect(forge.url).to eq(Blacksmith::Forge::PUPPETLABS_FORGE)
      expect(forge.password).to eq(stubbed_forge_password)
      expect(forge.username).to eq(username)
    end

    context 'when the credentials values are unset' do
      it 'raises an error' do
        expect do
          Blacksmith::Forge.new(nil, password, forge)
        end.to raise_error(/Could not find Puppet Forge credentials/)
      end
    end

    it 'loads credentials from home dir' do
      allow(File).to receive(:exist?).with('/home/mr_puppet/puppet-some-module/.puppetforge.yml').and_return(false)
      allow(File).to receive(:exist?).with('/home/mr_puppet/.puppetforge.yml').and_return(true)
      allow(YAML).to receive(:load_file).with('/home/mr_puppet/.puppetforge.yml').and_return({ 'username' => 'puppet-user' })

      subject = Blacksmith::Forge.new(nil, password, forge)
      expect(subject.username).to eq('puppet-user')
    end

    it 'loads credentials from project dir' do
      allow(File).to receive(:exist?).with('/home/mr_puppet/puppet-some-module/.puppetforge.yml').and_return(true)
      allow(File).to receive(:exist?).with('/home/mr_puppet/.puppetforge.yml').and_return(true)
      allow(YAML).to receive(:load_file).with('/home/mr_puppet/puppet-some-module/.puppetforge.yml').and_return({ 'username' => 'puppet-other-user' })

      subject = Blacksmith::Forge.new(nil, password, forge)
      expect(subject.username).to eq('puppet-other-user')
    end
  end

  describe 'push' do
    before { create_tarball }

    context 'when using a Forge API key' do
      # WebMock doesn't support `set_form()` yet: https://github.com/bblimke/webmock/issues/959
      # Disable it and use RSpec mocks instead
      before { WebMock.disable! }
      after { WebMock.enable! }

      let(:http) do
        http = instance_double(Net::HTTP)
        allow(http).to receive(:use_ssl=)
        http
      end
      let(:response_ok) do
        resp = instance_double(Net::HTTPOK, body: '{}', code: 200, message: 'OK')
        allow(resp).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        resp
      end

      it 'push the module' do
        subject.api_key = api_key
        subject.url = forge

        allow(Net::HTTP).to receive(:new).and_return(http)
        # Allow any POST and return OK always
        allow(http).to receive(:request).with(instance_of(Net::HTTP::Post)).and_return(response_ok)

        subject.push!(module_name, package)
        # Ensure the connection is to the right host & port
        expect(Net::HTTP).to have_received(:new).with('forgestagingapi.puppetlabs.com', 443)
        # Ensure the expected request actually happens
        expect(http).to have_received(:request).with(
          satisfy do |req|
            expect(req).to be_a(Net::HTTP::Post)
            expect(req.path).to eq('/v3/releases')
            expect(req['Content-Type']).to match(%r{multipart/form-data})
            expect(req['Authorization']).to eq("Bearer #{api_key}")
            expect(req['User-Agent']).to match(%r{^Blacksmith/#{Blacksmith::VERSION} Ruby/.* \(.*\)$}o)
          end,
        )
      end
    end
  end
end
