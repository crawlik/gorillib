require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name        = "gorillib"
  gem.homepage    = "http://infochimps.com/labs"
  gem.license     = "MIT"
  gem.summary     = %Q{include only what you need. No dependencies, no creep}
  gem.description = %Q{Gorillib: infochimps lightweight subset of ruby convenience methods}
  gem.email       = "coders@infochimps.org"
  gem.authors     = ["Infochimps"]

  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  gem.add_development_dependency "yard", "~> 0.6.0"
  gem.add_development_dependency "jeweler", "~> 1.5.2"
  gem.add_development_dependency "rcov", ">= 0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'yard'
YARD::Rake::YardocTask.new
