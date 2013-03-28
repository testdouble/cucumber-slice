require 'git'

module CucumberSlice
  module ListCore
    def list_features_under(path)
      glob = if path.include?('*')
        path
      else
        File.join(path, "**/*.feature")
      end

      Dir.glob(glob)
    end

    def format_feature_list(feature_list)
      feature_list.join(" ")
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

    #git stuff
    def git_repo_path
      find_up(Dir.pwd)
    end

    def files_changed_since(rev)
      git = Git.open(git_repo_path)
      (diff_files(git, rev) + changed_files(git)).uniq
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

      filtered_features = all_features.select do |feature|
        #read file
        #look for ^#=\s+depends_on .*$
        #expand all the depends_on paths
        # return true if depends_on paths intersect with changeset paths
      end
      changeset #delete
    end
  end
end
