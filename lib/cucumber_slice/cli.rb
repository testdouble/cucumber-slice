require 'thor'

module CucumberSlice
  class Cli < Thor

    desc "list", "list the features cucumber-slice thinks should run"
    long_desc <<-LONGDESC
      `cucumber-slice list` will print a list of all feature files that it
      thinks should be run based on the current changeset of files since the
      previous passing run.

      > $ cucumber-slice list --since a3989b6

      If the `since` option is not supplied, then HEAD is assumed and uncommitted
      changes in your working

      > $ cucumber-slice list

      In the event you don't want to filter out any features (perhaps following an
      unstable build), you can use the `--all` option to prevent filtering

      > $ cucumber-slice list --since a3989b6 --all true

      If the features you wish to filter are anywhere but <git_root>/features, you can specify them:

      > $ cucumber-slice list --since a3989b6 --features "project/features"

    LONGDESC
    method_option :since, :type => :string, :default => "HEAD", :banner => "REV"
    method_option :all, :type => :boolean, :default => false
    method_option :features, :default => "features", :aliases => ["f"]
    def list
      require 'cucumber_slice/lists_features'
      features = ListsFeatures.new(options[:features], options[:since], !!options[:all])
      puts features.list
    end

  end
end
