def run_turbo_install_template(path) system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/#{path}.rb",  __dir__)}" end

namespace :turbo do
  desc "Install Turbo into the app"
  task :install do
    if defined?(Webpacker::Engine)
      Rake::Task["turbo:install:webpacker"].invoke
    else
      Rake::Task["turbo:install:asset_pipeline"].invoke
    end
  end

  namespace :install do
    desc "Install Turbo into the app with asset pipeline"
    task :asset_pipeline do
      run_turbo_install_template "turbo_with_asset_pipeline"
    end

    desc "Install Turbo into the app with webpacker"
    task :webpacker do
      run_turbo_install_template "turbo_with_webpacker"
    end
  end
end
