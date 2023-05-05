require 'spec_helper'
require 'fileutils'

RSpec.shared_examples 'forge_push' do |_collection_class|
  it 'pushes the module' do
    subject.push!(module_name, package)
  end
end

RSpec.shared_context 'forge' do
  subject { Blacksmith::Forge.new(username, password, forge) }

  let(:api_key) { 'e52f78b62e97cb8d8db6659a73aa522cca0f5c74d4714e0ed0bdd10000000000' }
  let(:username) { 'johndoe' }
  let(:password) { 'secret' }
  let(:forge) { 'https://forgestagingapi.puppetlabs.com' }
  let(:module_name) { 'test' }
  let(:version) { '1.0.0' }
  let(:module_name) { 'maestrodev-test' }
  let(:spec_data) { File.join(__dir__, '..', 'data') }
  let(:spec_module) { File.join(spec_data, module_name) }
  let(:target) { File.expand_path(File.join(__dir__, '..', '..', 'pkg', module_name)) }
  let(:package) { "#{target}.tar.gz" }

  let(:headers) { { 'User-Agent' => %r{^Blacksmith/#{Blacksmith::VERSION} Ruby/.* \(.*\)$}o } }

  def create_tarball
    FileUtils.mkdir_p(target)

    # update version
    f = File.join(spec_module, 'metadata.json')
    metadata = JSON.parse File.read(f)
    metadata['version'] = "1.0.#{Random.rand(9_999_999)}"
    File.write(File.join(target, 'metadata.json'), JSON.pretty_generate(metadata))
    `cd '#{target}/..'; tar -czf #{module_name}.tar.gz #{module_name}`
  end
end
