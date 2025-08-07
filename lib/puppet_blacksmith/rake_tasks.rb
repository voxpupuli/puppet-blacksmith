require 'rake'
require 'rake/tasklib'
require 'puppet_blacksmith'

module Blacksmith
  class RakeTask < ::Rake::TaskLib
    attr_accessor :tag_pattern, :tag_message_pattern, :tag_sign, :commit_message_pattern, :build

    def initialize(*args, &)
      @build = true
      @task_name = args.shift || 'blacksmith'
      @desc = args.shift || 'Puppet Forge utilities'
      define(args, &)
    end

    def git
      git = Blacksmith::Git.new
      git.tag_pattern = @tag_pattern
      git.tag_message_pattern = @tag_message_pattern
      git.commit_message_pattern = @commit_message_pattern
      git.tag_sign = @tag_sign

      git
    end

    def define(args, &task_block)
      yield(*[self, args].slice(0, task_block.arity)) if task_block

      # clear any (auto-)pre-existing task
      [
        :build,
        :bump,
        'bump:major',
        'bump:minor',
        'bump:patch',
        'bump:full',
        :tag,
        :version,
        'version:next',
        'version:next:major',
        'version:next:minor',
        'version:next:patch',
        :bump_commit,
        'bump_commit:major',
        'bump_commit:minor',
        'bump_commit:patch',
        'bump_commit:full',
        :push,
        :clean,
        :release,
        :dependency,
      ].each do |t|
        Rake::Task.task_defined?("module:#{t}") && Rake::Task["module:#{t}"].clear
      end

      namespace :module do
        desc 'Build the module using puppet-modulebuilder'
        task :build do
          require 'puppet/modulebuilder'
          builder = Puppet::Modulebuilder::Builder.new(Dir.pwd)
          package_file = builder.build
          puts "Built #{package_file}"
        end

        namespace :bump do
          %i[major minor patch full].each do |level|
            desc "Bump module version to the next #{level.upcase} version"
            task level do
              m = Blacksmith::Modulefile.new
              v = m.bump!(level)
              puts "Bumping version from #{m.version} to #{v}"
            end
          end
        end

        desc 'Bump module to specific version number'
        task :bump_to_version, [:new_version] do |_t, targs|
          m = Blacksmith::Modulefile.new
          m.bump_to_version!(targs[:new_version])
          puts "Bumping version to #{targs[:new_version]}"
        end

        desc 'Bump module version to the next patch'
        task :bump do
          m = Blacksmith::Modulefile.new
          v = m.bump_patch!
          puts "Bumping version from #{m.version} to #{v}"
        end

        desc 'Git tag with the current module version'
        task :tag do
          m = Blacksmith::Modulefile.new
          git.tag!(m.version)
        end

        namespace :version do
          desc 'Get next module version'
          task :next do
            m = Blacksmith::Modulefile.new
            puts m.increase_version(m.version, 'patch')
          end

          %i[major minor patch].each do |level|
            desc "Get the next #{level.upcase} version"
            task :"next:#{level}" do
              m = Blacksmith::Modulefile.new
              puts m.increase_version(m.version, level)
            end
          end
        end

        desc 'Get current module version'
        task :version do
          m = Blacksmith::Modulefile.new
          puts m.version
        end

        namespace :bump_commit do
          %i[major minor patch full].each do |level|
            desc "Bump module version to the next #{level.upcase} version and git commit"
            task level => :"bump:#{level}" do
              m = Blacksmith::Modulefile.new
              git.commit_modulefile!(m.version)
            end
          end
        end

        desc 'Bump version and git commit'
        task bump_commit: :bump do
          m = Blacksmith::Modulefile.new
          git.commit_modulefile!(m.version)
        end

        desc 'Push module to the Puppet Forge'
        task push: :'module:build' do
          m = Blacksmith::Modulefile.new
          forge = Blacksmith::Forge.new
          puts "Uploading to Puppet Forge #{m.namespace}/#{m.name}"
          forge.push!(m.name, nil, m.namespace, m.version)
        end

        desc 'Runs clean again'
        task :clean do
          puts 'Cleaning for module build'
          if Rake::Task.task_defined?(:clean)
            Rake::Task['clean'].execute
          else
            # identical to the clean task in puppetlabs_spec_helper on 2021-07-30
            # https://github.com/puppetlabs/puppetlabs_spec_helper/blob/24d7b21280a26cc682146839f41dbf1c0793e494/lib/puppetlabs_spec_helper/rake_tasks.rb#L165-L168
            require 'fileutils'
            FileUtils.rm_rf('pkg/')
          end
        end

        desc 'Release the Puppet module, doing a clean, build, bump_commit, tag, push and git push.'
        release_dependencies = if @build
                                 %i[clean module:build bump_commit tag
                                    push]
                               else
                                 %i[clean bump_commit tag]
                               end
        task release: release_dependencies do
          puts 'Pushing to remote git repo'
          git.push!
        end

        desc 'Set specific module dependency version'
        task :dependency, [:module_name, :version] do |_t, targs|
          mn = targs[:module_name]
          mv = targs[:version]
          m = Blacksmith::Modulefile.new
          m.bump_dep! mn, mv
          puts "Updated module dependency #{mn} to #{mv}"
        end
      end
    end
  end
end

Blacksmith::RakeTask.new
