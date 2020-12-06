# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

all_tasks = %i[test]

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
  all_tasks << "rubocop"
rescue LoadError
  puts "=> Couldn't load Rubocop rake tasks"
end

task default: all_tasks
