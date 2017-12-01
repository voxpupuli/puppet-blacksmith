require 'spec_helper'

describe 'Blacksmith::Git' do

  subject { Blacksmith::Git.new(path) }
  let(:path) { File.expand_path(File.join(File.dirname(__FILE__), '../../tmp/git_test')) }
  let(:version) { '1.0.0' }
  let(:metadata_file) { "metadata.json" }

  before do
    FileUtils.rm_rf path
    FileUtils.mkdir_p(path)
    `git init #{path}`
    FileUtils.touch(File.join(path, metadata_file))
    `cd #{path} && git add #{metadata_file} && git commit -am "Init"`
  end

  shared_examples_for :git do
    describe 'has_tag?' do
      context 'with a tag' do
        before { subject.tag!(version) }
        it { expect(subject.has_tag?("v#{version}")).to be true }
      end

      context 'with a partial match' do
        before { subject.tag!(version) }
        it { expect(subject.has_tag?(version)).to be false }
      end

      context 'without a tag' do
        it { expect(subject.has_tag?('something')).to be false }
      end
    end

    describe 'has_tag?' do
      context 'with a tag' do
        before { subject.tag!(version) }
        it { expect(subject.has_version_tag?(version)).to be true }
      end

      context 'without a tag' do
        it { expect(subject.has_version_tag?('something')).to be false }
      end
    end

    describe 'tag!' do
      context 'basic tag' do
        before { subject.tag!(version) }
        it "should have the tag" do
          out = `cd #{path} && git tag`
          expect(out.chomp).to match(/^v1.0.0$/)
        end
      end

      context 'signed tag without pattern' do
        before do
          subject.tag_message_pattern = nil
          subject.tag_sign = true
        end

        it { expect { subject.tag!(version) }.to raise_error(Blacksmith::Error, /Signed tags require messages/)}
      end

      context 'signed tag with pattern' do
        before do
          subject.tag_message_pattern = 'Version %s'
          subject.tag_sign = true
          allow(subject).to receive(:exec_git).with(['tag', 'v1.0.0', '-m', 'Version 1.0.0', '-s']).and_return(true)
        end

        it { expect(subject.tag!(version)).to be true }
      end
    end

    describe 'commit_modulefile' do
      before do
        open(File.join(subject.path, metadata_file), 'a') { |f|
          f.puts "more text"
        }
      end

      it "should commit the metadata file" do
        expect(subject.commit_modulefile!(version)).to match(/\[blacksmith\] Bump version to #{version}/)
      end
    end

    describe 'exec_git' do
      let(:cmd) { ['log'] }
      let(:stdin) { nil }
      let(:stdout) { '' }
      let(:stderr) { '' }
      let(:exit_code) { double('exit_code', :success? => true) }
      let(:wait_thr) { double('wait_thr', :value => exit_code) }

      context 'when git succeeds' do
        before do
          allow(Open3).to receive(:popen3). \
            with('git', '--git-dir', File.join(path, '.git'), '--work-tree', path, *cmd). \
            and_yield(nil, double(:read => stdout), double(:read => stderr), wait_thr)
          expect { subject.send(:exec_git, cmd) }.to_not raise_error
        end

        context 'when stderr is empty' do
          it {}
        end

        context 'when stderr is not empty' do
          let(:stderr) { 'some error' }
          it {}
        end

      end

      context 'when git fails' do
        # this spec fails on jruby, can't detect exit code of script
        context 'when stderr is empty' do
          let(:cmd) { [] } # exits with 1
          it { expect { subject.send(:exec_git, cmd) }.to raise_error(Blacksmith::Error, /^Command .* failed with exit status.*1.*$/) }
        end

        context 'when stderr is not empty' do
          let(:cmd) { ["help", "xxxx"] } # exits with 1 and prints to stdout
          it { expect { subject.send(:exec_git, cmd) }.to raise_error(Blacksmith::Error, /No manual entry for gitxxx/) }
        end
      end
    end
  end

  context "Using metadata.json" do
    it_behaves_like :git
  end
end
