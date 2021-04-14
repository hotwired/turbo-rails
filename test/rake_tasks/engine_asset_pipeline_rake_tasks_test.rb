require "turbo_test"

class EngineAssetPipelineRakeTasksTest < Minitest::Test
  def setup
    app_layout = File.expand_path("../fixtures/application.html.erb", __dir__)
    gemfile = File.expand_path("../fixtures/Gemfile", __dir__)
    cablefile = File.expand_path("../fixtures/cable.yml", __dir__)

    FileUtils.mkpath File.expand_path("mounted_apps/asset_pipeline/app/views/layouts/", __dir__)
    FileUtils.cp app_layout, File.expand_path("mounted_apps/asset_pipeline/app/views/layouts/application.html.erb", __dir__)
    FileUtils.cp gemfile, File.expand_path("mounted_apps/asset_pipeline/Gemfile", __dir__)
    FileUtils.cp cablefile, File.expand_path("mounted_apps/asset_pipeline/config/cable.yml", __dir__)
  end

  def teardown
    FileUtils.rm File.expand_path("mounted_apps/asset_pipeline/app/views/layouts/application.html.erb", __dir__)
    FileUtils.rm File.expand_path("mounted_apps/asset_pipeline/Gemfile", __dir__)
    FileUtils.rm File.expand_path("mounted_apps/asset_pipeline/config/cable.yml", __dir__)
  end

  def test_tasks_are_listed_on_asset_pipeline_app
    app_path = File.expand_path("mounted_apps/asset_pipeline", __dir__)
    output = Dir.chdir(app_path) { `rake -T` }

    assert_includes output, "app:turbo"
    assert_includes output, "app:turbo:install"
    assert_includes output, "app:turbo:install:asset_pipeline"
  end

  def test_asset_pipeline_based_install
    app_path = File.expand_path("mounted_apps/asset_pipeline", __dir__)
    output = Dir.chdir(app_path) { `bundle exec rake app:turbo:install` }

    assert_includes output, "Turbo successfully installed ⚡"
  end
end
