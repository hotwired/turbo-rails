module RakeTaskTestHelper
  def setup
    app_layout = File.join(fixtures_path, "application.html.erb")
    gemfile = File.join(fixtures_path, "Gemfile")
    cablefile = File.join(fixtures_path, "cable.yml")

    FileUtils.mkpath File.join(app_path, "app", "views", "layouts")
    FileUtils.cp app_layout, File.join(app_path, "app", "views", "layouts", "application.html.erb")
    FileUtils.cp gemfile, File.join(app_path, "Gemfile")
    FileUtils.cp cablefile, File.join(app_path, "config", "cable.yml")
  end

  def teardown
    FileUtils.rm File.join(app_path, "app", "views", "layouts", "application.html.erb")
    FileUtils.rm File.join(app_path, "Gemfile")
    FileUtils.rm File.join(app_path, "config", "cable.yml")
  end

  def fixtures_path
    File.expand_path("fixtures/files", __dir__)
  end
end
