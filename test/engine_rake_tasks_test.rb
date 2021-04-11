require "turbo_test"

class EngineRakeTasksTest < Minitest::Test
  def test_tasks_mounted_on_webpacker_app
    app_path = File.expand_path("webpacker_mounted_app", __dir__)
    output = Dir.chdir(app_path) { `rake -T` }
    assert_includes output, "app:webpacker"
  end

  def test_tasks_mounted_on_asset_pipeline_app
    app_path = File.expand_path("asset_pipeline_mounted_app", __dir__)
    output = Dir.chdir(app_path) { `rake -T` }
    assert_includes output, "app:turbo"
  end

  def test_asset_pipeline_based_install
    app_path = File.expand_path("asset_pipeline_mounted_app", __dir__)
    output = Dir.chdir(app_path) { `bundle exec rake app:turbo:install` }
    assert_includes output, "Turbo successfully installed ⚡"
  end

  def test_webpacker_based_install
    app_path = File.expand_path("webpacker_mounted_app", __dir__)
    output = Dir.chdir(app_path) { `bundle exec rake app:turbo:install` }
    assert_includes output, "Turbo successfully installed ⚡"
  end
end
