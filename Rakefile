# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["./test/**/*_test.rb"]
  t.warning = false
end

RuboCop::RakeTask.new

task default: %i[test rubocop]
