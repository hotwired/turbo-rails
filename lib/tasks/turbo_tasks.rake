namespace :turbo do
  desc "Install Turbo into the app. If webpacker is configured delegates to the webpacker, else uses asset pipeline"
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
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/turbo_with_asset_pipeline.rb", __dir__)}"
    end

    desc "Install Turbo into the app with webpacker"
    task :webpacker do
      system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/turbo_with_webpacker.rb", __dir__)}"
    end
  end
end
