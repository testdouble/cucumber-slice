# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cucumber_slice/version'

Gem::Specification.new do |gem|
  gem.name          = "cucumber-slice"
  gem.version       = CucumberSlice::VERSION
  gem.authors       = ["Justin Searls"]
  gem.email         = ["searls@gmail.com"]
  gem.description   = <<-TEXT.gsub /^\s+/, ""
                        This tool can be used both locally and by build systems to
                        quickly narrow down which Cucumber features to run based on
                        which features may have been impacted by a code change.

                        Provides a CLI that filters Cucumber features based on
                        changes to production code since a specified git revision.

                        This is particular useful in systems of wide logical breadth,
                        where each individual commit is unlikely to have an impact on the
                        vast majority of the system's behavior.
                      TEXT
  gem.summary       = %q{Helps you narrow down which Cucumber features to run based on recent code changes}
  gem.homepage      = "https://github.com/testdouble/cucumber-slice"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'thor', '~> 0.14'
  gem.add_dependency 'git', '~> 1.2.5'
end
