# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'

desc 'Run the application'
task :run do
  sh 'ruby ./bin/family_tree.rb ./data/actions.txt'
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

desc 'Run all tests'
task test: :spec

task default: :test
