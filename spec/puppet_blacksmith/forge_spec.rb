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
      before do
        stub_request(:post, "#{forge}/v3/releases").with(
          headers: headers.merge({ 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                                   'Authorization' => 'Bearer e52f78b62e97cb8d8db6659a73aa522cca0f5c74d4714e0ed0bdd10000000000', 'Content-Type' => %r{\Amultipart/form-data;}, }),
        ) do |request|
          request.body =~ %r{Content-Disposition: form-data; name="file"; filename="maestrodev-test.tar.gz"\r\nContent-Type: application/gzip}
        end.to_return(status: 200, body: File.read(File.join(spec_data, 'response.json')), headers: {})
      end

      it 'push the module' do
        subject.api_key = api_key
        subject.url = forge

        resp = subject.push!(module_name, package)
        expect(resp.code).to eq(200)
      end
    end
  end
end
