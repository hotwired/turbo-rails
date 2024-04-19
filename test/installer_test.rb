require 'app_helper'

class InstallerTest < ActiveSupport::TestCase
  include RailsAppHelpers
  include ActiveSupport::Testing::Isolation

  test "installer" do
    with_new_rails_app do
      if Rails::VERSION::MAJOR >= 7 && File.read("Gemfile").match?(/importmap-rails/)
        run_command("bin/rails", "importmap:install")
      end
      run_command("bin/rails", "turbo:install")

      if Gem::Version.new(Rails.version) >= Gem::Version.new("7.0")
        assert_match %(import "@hotwired/turbo-rails"\n), File.read("app/javascript/application.js")
      end

      if Rails::VERSION::MAJOR >= 7
        assert_match %(pin "@hotwired/turbo-rails", to: "turbo.min.js"), File.read("config/importmap.rb")
      else
        assert_match "@hotwired/turbo-rails", File.read("package.json")
        assert_match "@hotwired/turbo-rails", File.read("yarn.lock")
      end
    end
  end

  test "installer with no javascript" do
    with_new_rails_app %w[--skip-javascript] do
      out, = run_command("bin/rails", "turbo:install")

      assert_match "You must either be running with node (package.json) or importmap-rails (config/importmap.rb) to use this gem.", out
    end
  end

  test "installer with pre-existing application.js" do
    with_new_rails_app do
      if Rails::VERSION::MAJOR >= 7 && File.read("Gemfile").match?(/importmap-rails/)
        run_command("bin/rails", "importmap:install")
      end
      File.write("app/javascript/application.js", "// pre-existing")
      run_command("bin/rails", "turbo:install")

      assert_match "// pre-existing", File.read("app/javascript/application.js")
      assert_match %(import "@hotwired/turbo-rails"\n), File.read("app/javascript/application.js")
    end
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new("7.1")
    test "installer with bun" do
      with_new_rails_app %w[--javascript=bun] do
        run_command("bin/rails", "javascript:install:bun")
        run_command("bin/rails", "turbo:install")

        assert_match %(import "@hotwired/turbo-rails"\n), File.read("app/javascript/application.js")

        assert_match "@hotwired/turbo-rails", File.read("package.json")
      end
    end
  end
end
