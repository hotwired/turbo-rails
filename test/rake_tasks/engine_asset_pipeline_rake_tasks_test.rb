require 'rake_task_test_helper'

class EngineAssetPipelineRakeTasksTest < Minitest::Test
  include RakeTaskTestHelper

  def test_tasks_are_listed_on_asset_pipeline_app
    output = Dir.chdir(app_path) { `rake -T` }

    assert_includes output, "app:turbo"
    assert_includes output, "app:turbo:install"
    assert_includes output, "app:turbo:install:asset_pipeline"
  end

  def test_asset_pipeline_based_install
    output = Dir.chdir(app_path) { `bundle exec rake app:turbo:install` }

    assert_includes output, "Turbo successfully installed ⚡"
  end

  private

  def app_path
    File.expand_path("mounted_apps/asset_pipeline", __dir__)
  end
end
