require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["./test/**/*_test.rb"]
  t.warning = false
end

task default: :test

