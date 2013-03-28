require 'git'

module CucumberSlice
  module ListCore
    #feature stuff
    def list_features_under(path)
      glob = if path.include?('*')
        path
      else
        File.join(path, "**/*.feature")
      end

      Dir.glob(File.join(git_repo_path, glob))
    end

    def format_feature_list(feature_list)
      feature_list.join(" ")
    end

    def dependencies_declared_in(feature_path)
      dependencies = nil
      File.open(feature_path) do |feature|
        dependencies = feature.each_line.map do |line|
          if match = line.match(/^#=\s*?depends_on (.*)$/)
            match[1]
          end
        end.compact
      end
      dependencies
    end

    def any_dependencies_in_changeset?(dependencies, changeset)
      (dependencies & changeset).any?
    end

    #file stuff
    def find_up(dir, root_checked = false)
      raise "No git repository found at or above `#{Dir.pwd}`!" if root_checked
      is_dir?(File.join(dir, ".git")) ?  dir : find_up(File.join(dir,'..'), is_root?(dir))
    end

    def is_dir?(path)
      File.exist?(path) && File.ftype(path) == "directory"
    end

    def is_root?(path)
      File.expand_path(path) == "/"
    end

    def expand_globs(patterns)
      expand_paths(patterns.map do |pattern|
        Dir.glob(File.join(git_repo_path, pattern))
      end.flatten).compact.uniq
    end

    def expand_paths(paths)
      paths.map {|path| File.expand_path(path) }
    end

    #git stuff
    def git_repo_path
      File.expand_path(find_up(Dir.pwd))
    end

    def files_changed_since(rev)
      git = Git.open(git_repo_path)
      changed_files = diff_files(git, rev) + changed_files(git)

      expand_paths(changed_files.map {|p| File.join(git_repo_path, p)}).uniq
    end

    def diff_files(git, since)
      git.diff(since, "HEAD").map(&:path)
    end

    def changed_files(git)
      git.status.changed.map(&:first)
    end
  end

  class ListsFeatures
    include ListCore

    def initialize(path, rev, disabled)
      @path = path
      @rev = rev
      @disabled = disabled
    end

    def list
      all_features = list_features_under(@path)
      return format_feature_list(all_features) if @disabled
      changeset = files_changed_since(@rev)

      format_feature_list(all_features.select do |feature_path|
        dependency_patterns = dependencies_declared_in(feature_path)
        dependency_paths = expand_globs(dependency_patterns) + [feature_path]
        any_dependencies_in_changeset?(dependency_paths, changeset)
      end)
    end
  end
end
