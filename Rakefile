require 'bundler'
require 'rspec/core/rake_task'

task :default => :build
task :build => :spec

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/cases/**/*_spec.rb"
end
