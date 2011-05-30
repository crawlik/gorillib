require 'rubygems' unless defined?(Gem)
require 'spork'
require 'rspec'

Spork.prefork do # Must restart for changes to config / code from libraries loaded here
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'support'))
  Dir[File.join(File.dirname(__FILE__), 'support/matchers/*.rb')].each {|f| require f}

  RSpec.configure do |config|
  end
end

Spork.each_run do # This code will be run each time you run your specs.
  RSpec.configure do |config|
  end
end
