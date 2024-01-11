require "rails"
require "rails/test_help"
require "fileutils"

module RailsAppHelpers
  private
  def create_new_rails_app(app_dir, options=[])
    require "rails/generators/rails/app/app_generator"
    Rails::Generators::AppGenerator.start([app_dir, *options, "--skip-bundle", "--skip-bootsnap", "--quiet"])

    Dir.chdir(app_dir) do
      gemfile = File.read("Gemfile")

      gemfile.gsub!(/^gem ["']turbo-rails["'].*/, "")
      gemfile << %(gem "turbo-rails", path: #{File.expand_path("..", __dir__).inspect}\n)

      if Rails::VERSION::PRE == "alpha"
        gemfile.gsub!(/^gem ["']rails["'].*/, "")
        gemfile << %(gem "rails", path: #{Gem.loaded_specs["rails"].full_gem_path.inspect}\n)
      end

      File.write("Gemfile", gemfile)

      run_command("bundle", "install")
    end
  end

  def with_new_rails_app(options=[], &block)
    require "digest/sha1"
    variant = [RUBY_VERSION, Gem.loaded_specs["rails"].full_gem_path,]
    app_name = "turbo_test_app_#{Digest::SHA1.hexdigest(variant.to_s)}"

    Dir.mktmpdir do |tmpdir|
      create_new_rails_app("#{tmpdir}/#{app_name}", *options)
      Dir.chdir("#{tmpdir}/#{app_name}", &block)
    end
  end

  def run_command(*command)
    Bundler.with_unbundled_env do
      capture_subprocess_io { system(*command, exception: true) }
    end
  end
end
