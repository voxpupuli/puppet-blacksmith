require 'spec_helper'
require 'fileutils'

RSpec.shared_examples 'forge_push' do |collection_class|
  it "should push the module" do
    subject.push!(module_name, package)
  end
end

RSpec.shared_context "forge" do
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

  let(:headers) { { 'User-Agent' => %r{^Blacksmith/#{Blacksmith::VERSION} Ruby/.* \(.*\)$} } }

  def create_tarball
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
end
