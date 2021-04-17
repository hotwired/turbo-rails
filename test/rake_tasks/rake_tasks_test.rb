require 'rake_task_test_helper'

class RakeTasksTest < Minitest::Test
  include RakeTaskTestHelper

  def test_rake_tasks_are_listed
    output = Dir.chdir(app_path) { `rake -T` }

    assert_includes output, "turbo:install"
    assert_includes output, "turbo:install:asset_pipeline"
    assert_includes output, "turbo:install:webpacker"
  end

  def test_install
    output = Dir.chdir(app_path) { `bundle exec rake turbo:install` }

    assert_includes output, "Turbo successfully installed ⚡"
  end

  private

  def app_path
    File.expand_path("test_app", __dir__)
  end
end
