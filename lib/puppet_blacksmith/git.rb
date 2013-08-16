require 'open3'

module Blacksmith
  class Git

    attr_accessor :path

    def initialize(path = ".")
      @path = File.expand_path(path)
    end

    def tag!(version)
      exec_git "tag v#{version}"
    end

    def commit_modulefile!
      s = exec_git "add Modulefile"
      s += exec_git "commit -m '[blacksmith] Bump version'"
      s
    end

    def push!
      s = exec_git "push"
      s += exec_git "push --tags"
      s
    end

    def exec_git(cmd)
      out = ""
      err = ""
      # wait_thr is nil in JRuby < 1.7.5 see http://jira.codehaus.org/browse/JRUBY-6409
      new_cmd = "git --git-dir=#{File.join(path, '.git')} --work-tree=#{path} #{cmd}"
      Open3.popen3(new_cmd) do |stdin, stdout, stderr, wait_thr|
        out = stdout.read
        err = stderr.read
        # exit_status = wait_thr.value
      end
      exit_status = $?
      raise Blacksmith::Error, err unless exit_status.success?
      return out
    end
  end
end
