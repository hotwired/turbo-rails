namespace :turbo do
  desc "Install Turbo into the app"
  task :install do
    system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/turbo.rb", __dir__)}"
  end
end
