require 'thor'

module CucumberSlice
  class Cli < Thor

    desc "list", "list the features cucumber-slice thinks should run"
    long_desc <<-LONGDESC
      `cucumber-slice list` will print a list of all feature files that it
      thinks should be run based on the current changeset of files since the
      previous passing run.

      > $ cucumber-slice list --from a3989b6

      In the event you don't want to filter out any features (perhaps following an
      unstable build), you can use the `--all` option to prevent filtering

      > $ cucumber-slice list --from a3989b6 --all true

    LONGDESC
    option :from, :type => :string, :required => true, :banner => "REF"
    option :all, :type => :boolean, :default => false
    option :features, :default => "features", :aliases => ["f"]
    def list
      puts "all: #{options[:all]}"
      puts "from: #{options[:from]}"
      puts "features: #{options[:features]}"
    end

  end
end
