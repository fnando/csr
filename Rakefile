require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:spec) do |t|
  t.libs << 'spec'
  t.test_files = Dir['./spec/**/*_spec.rb']
end

task :default => :spec

