def run_turbo_install_template(path)
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/#{path}.rb",  __dir__)}"
end

def redis_installed?
  system('which redis-server')
end

def switch_on_redis_if_available
  if redis_installed?
    Rake::Task["turbo:install:redis"].invoke
  else
    puts "Run turbo:install:redis to switch on Redis and use it in development for turbo streams"
  end
end

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
      switch_on_redis_if_available
    end

    desc "Install Turbo into the app with webpacker"
    task :webpacker do
      run_turbo_install_template "turbo_with_webpacker"
      switch_on_redis_if_available
    end

    desc "Switch on Redis and use it in development"
    task :redis do
      run_turbo_install_template "turbo_needs_redis"
    end
  end
end
