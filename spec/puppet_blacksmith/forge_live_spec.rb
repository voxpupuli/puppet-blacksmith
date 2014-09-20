require 'spec_helper'
require_relative 'forge_shared'
require 'fileutils'

# Run tests against the real Forge staging API
describe 'Blacksmith::Forge', :live => true do
  include_context 'forge'
  let(:username) { nil }

  describe 'push' do
    before { create_tarball }
    include_examples 'forge_push'
  end
end
