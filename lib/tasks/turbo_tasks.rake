def run_turbo_install_template(path, nspace = nil)
  system "#{RbConfig.ruby} #{Rails.root}/bin/rails #{nspace}app:template LOCATION=#{File.expand_path("../install/#{path}.rb",  __dir__)}"
end

namespace :turbo do
  desc "Install Turbo into the app"
  task :install do |task|
    nspace = task.name.split(/turbo:install/).first
    if defined?(Webpacker::Engine)
      Rake::Task["#{nspace}turbo:install:webpacker"].invoke
    else
      Rake::Task["#{nspace}turbo:install:asset_pipeline"].invoke
    end
  end

  namespace :install do
    desc "Install Turbo into the app with asset pipeline"
    task :asset_pipeline do |task|
      nspace = task.name.split(/turbo:install/).first
      run_turbo_install_template "turbo_with_asset_pipeline", nspace
    end

    desc "Install Turbo into the app with webpacker"
    task :webpacker do |task|
      nspace = task.name.split(/turbo:install/).first
      run_turbo_install_template "turbo_with_webpacker", nspace
    end
  end
end
