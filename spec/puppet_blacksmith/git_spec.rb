require 'spec_helper'

describe 'Blacksmith::Git' do

  subject { Blacksmith::Git.new(path) }
  let(:path) { File.join(File.dirname(__FILE__), '../../tmp/git_test') }
  let(:version) { '1.0.0' }

  before do
    FileUtils.rm_rf path
    FileUtils.mkdir_p(path)
    `git init #{path}`
  end

  shared_examples_for :git do
    describe 'tag!' do
      before { subject.tag!(version) }
      it "should have the tag" do
        out = `cd #{path} && git tag`
        expect(out.chomp).to match(/^v1.0.0$/)
      end
    end

    describe 'exec_git' do
      let(:cmd) { 'log' }
      let(:stdin) { nil }
      let(:stdout) { '' }
      let(:stderr) { '' }
      let(:exit_code) { double('exit_code', :success? => true) }
      let(:wait_thr) { double('wait_thr', :value => exit_code) }

      context 'when git succeeds' do
        before do
          allow(Open3).to receive(:popen3).and_yield(nil, double(:read => stdout), double(:read => stderr), wait_thr)
          expect { subject.exec_git(cmd) }.to_not raise_error
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
        before { allow(subject).to receive(:git_cmd_with_path) {cmd} }

        # this spec fails on jruby, can't detect exit code of script
        context 'when stderr is empty' do
          let(:cmd) { "git" } # exits with 1
          it { expect { subject.exec_git(cmd) }.to raise_error(Blacksmith::Error, /^Command .* failed with exit status.*1$/) }
        end

        context 'when stderr is not empty' do
          let(:cmd) { "git help xxxx" } # exits with 1 and prints to stdout
          it { expect { subject.exec_git(cmd) }.to raise_error(Blacksmith::Error, /No manual entry for gitxxx/) }
        end
      end
    end
  end

  context "Using Modulefile" do
    before do
      FileUtils.touch(File.join(path, "Modulefile"))
      `cd #{path} && git add Modulefile && git commit -am "Init"`
    end
    it_behaves_like :git
  end

  context "Using metadata.json" do
    before do
      FileUtils.touch(File.join(path, "metadata.json"))
      `cd #{path} && git add metadata.json && git commit -am "Init"`
    end
    it_behaves_like :git
  end
end
