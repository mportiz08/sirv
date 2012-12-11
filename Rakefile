require 'rake'
require 'rspec/core/rake_task'

task :default => :test

desc 'Open an irb session preloaded with this library.'
task :console do
  sh 'irb -I lib/ -r sirv'
end

RSpec::Core::RakeTask.new(:spec)

desc 'Run tests.'
task :test => :spec
