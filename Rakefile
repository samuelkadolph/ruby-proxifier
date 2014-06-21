require 'bundler/gem_tasks'
require 'rake/testtask'

task default: :test

Rake::TestTask.new do |task|
  task.libs << 'lib' << 'spec'
  task.pattern = 'spec/**/*_spec.rb'
  task.verbose = true
end
