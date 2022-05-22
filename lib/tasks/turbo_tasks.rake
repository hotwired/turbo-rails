def run_turbo_install_template(path)
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/#{path}.rb", __dir__)}"
end

def redis_installed?
  Gem.win_platform? ?
    system('where redis-server > NUL 2>&1') : 
    system('which redis-server > /dev/null')
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
    if Rails.root.join("config/importmap.rb").exist?
      Rake::Task["turbo:install:importmap"].invoke
    elsif Rails.root.join("package.json").exist?
      Rake::Task["turbo:install:node"].invoke
    else
      puts "You must either be running with node (package.json) or importmap-rails (config/importmap.rb) to use this gem."
    end
  end

  namespace :install do
    desc "Install Turbo into the app with asset pipeline"
    task :importmap do
      run_turbo_install_template "turbo_with_importmap"
      switch_on_redis_if_available
    end

    desc "Install Turbo into the app with webpacker"
    task :node do
      run_turbo_install_template "turbo_with_node"
      switch_on_redis_if_available
    end

    desc "Switch on Redis and use it in development"
    task :redis do
      run_turbo_install_template "turbo_needs_redis"
    end
  end
end
