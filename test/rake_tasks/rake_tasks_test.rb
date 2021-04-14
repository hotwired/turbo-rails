require "turbo_test"

class RakeTasksTest < Minitest::Test
  def setup
    app_layout = File.expand_path("../fixtures/application.html.erb", __dir__)
    gemfile = File.expand_path("../fixtures/Gemfile", __dir__)
    cablefile = File.expand_path("../fixtures/cable.yml", __dir__)

    FileUtils.mkpath File.expand_path("test_app/app/views/layouts", __dir__)
    FileUtils.cp app_layout, File.expand_path("test_app/app/views/layouts/application.html.erb", __dir__)
    FileUtils.cp gemfile, File.expand_path("test_app/Gemfile", __dir__)
    FileUtils.cp cablefile, File.expand_path("test_app/config/cable.yml", __dir__)
  end

  def teardown
    FileUtils.rm File.expand_path("test_app/app/views/layouts/application.html.erb", __dir__)
    FileUtils.rm File.expand_path("test_app/Gemfile", __dir__)
    FileUtils.rm File.expand_path("test_app/config/cable.yml", __dir__)
  end

  def test_rake_tasks_are_listed
    test_app_path = File.expand_path("test_app", __dir__)
    output = Dir.chdir(test_app_path) { `rake -T` }

    assert_includes output, "turbo:install"
    assert_includes output, "turbo:install:asset_pipeline"
    assert_includes output, "turbo:install:webpacker"
  end

  def test_install
    app_path = File.expand_path("test_app", __dir__)
    output = Dir.chdir(app_path) { `bundle exec rake turbo:install` }
    assert_includes output, "Turbo successfully installed ⚡"
  end
end
