require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = FileList["test/**/*_test.rb"]
  test.warning = false
end

task default: :test
