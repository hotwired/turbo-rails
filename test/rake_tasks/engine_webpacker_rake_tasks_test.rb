require 'rake_task_test_helper'

class EngineWebpackerRakeTasksTest < Minitest::Test
  include RakeTaskTestHelper

  def teardown
    nmodules_path = File.join(app_path, "node_modules")
    FileUtils.rm_rf nmodules_path if File.directory?(nmodules_path)
    super
  end

  def test_tasks_are_listed_on_webpacker_app
    output = Dir.chdir(app_path) { `rake -T` }

    assert_includes output, "app:turbo"
    assert_includes output, "app:turbo:install"
    assert_includes output, "app:turbo:install:webpacker"
  end

  def test_webpacker_based_install
    output = Dir.chdir(app_path) { `bundle exec rake app:turbo:install` }

    assert_includes output, "Turbo successfully installed ⚡"
  end

  private

  def app_path
    File.expand_path("mounted_apps/webpacker", __dir__)
  end
end
