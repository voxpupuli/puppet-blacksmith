require 'spec_helper'

describe 'Blacksmith::Git' do

  subject { Blacksmith::Git.new(path) }
  let(:path) { File.join(File.dirname(__FILE__), '../../tmp/git_test') }
  let(:version) { '1.0.0' }

  before do
    FileUtils.rm_rf path
    FileUtils.mkdir_p(path)
    `git init #{path}`
    FileUtils.touch(File.join(path, "Modulefile"))
    `cd #{path} && git add Modulefile && git commit -am "Init"`
  end

  describe 'tag!' do
    before { subject.tag!(version) }
    it "should have the tag" do
      out = `cd #{path} && git tag`
      out.chomp.should match(/^v1.0.0$/)
    end
  end
end
