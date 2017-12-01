require 'open3'

module Blacksmith
  class Git

    attr_accessor :path, :tag_pattern, :tag_message_pattern, :tag_sign, :commit_message_pattern
    attr_writer :tag_pattern, :tag_message_pattern, :tag_sign, :commit_message_pattern

    # Pattern to use for tags, %s is replaced with the actual version
    def commit_message_pattern
      @commit_message_pattern || "[blacksmith] Bump version to %s"
    end

    def tag_pattern
      @tag_pattern || 'v%s'
    end

    def tag_message_pattern
      @tag_message_pattern
    end

    def tag_sign
      @tag_sign
    end

    def initialize(path = ".")
      @path = File.expand_path(path)
    end

    def has_tag?(tag)
      exec_git(['tag', '--list', tag]).strip == tag
    end

    def has_version_tag?(version)
      tag = tag_pattern % version
      has_tag? tag
    end

    def tag!(version)
      tag = tag_pattern % version
      command = ["tag", tag]
      if tag_message_pattern
        tag_message = tag_message_pattern % version
        command += ["-m", tag_message]
      end
      if tag_sign
        raise Blacksmith::Error, 'Signed tags require messages - set tag_message_pattern' unless tag_message_pattern
        command += ["-s"]
      end
      exec_git command
    end

    def commit_modulefile!(version)
      files = Blacksmith::Modulefile::FILES.select {|f| File.exists?(File.join(@path,f))}
      message = commit_message_pattern % version
      s = exec_git ["add"] + files
      s += exec_git ["commit", "-m", message]
      s
    end

    def push!
      s = exec_git ["push"]
      s += exec_git ["push", "--tags"]
      s
    end

    private

    def exec_git(cmd)
      out = ""
      err = ""
      exit_status = nil
      new_cmd = ["git", "--git-dir", File.join(@path, '.git'), "--work-tree", @path] + cmd
      # wait_thr is nil in JRuby < 1.7.5 see http://jira.codehaus.org/browse/JRUBY-6409
      Open3.popen3(*new_cmd) do |stdin, stdout, stderr, wait_thr|
        out = stdout.read
        err = stderr.read
        exit_status = wait_thr.nil? ? nil : wait_thr.value
      end
      if exit_status.nil?
        raise Blacksmith::Error, "Command #{new_cmd} failed with stderr:\n#{err}#{"\nstdout:\n" + out unless out.empty?}" unless err.empty?
      elsif !exit_status.success?
        msg = err.empty? ? out : err
        msg = "\n#{msg}" unless msg.empty?
        raise Blacksmith::Error, "Command #{new_cmd} failed with exit status #{exit_status}#{msg}"
      end
      return out
    end
  end
end
