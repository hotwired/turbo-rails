# Some Rails versions use commonJS(require) others use ESM(import).
TURBOLINKS_REGEX = /(import .* from "turbolinks".*\n|require\("turbolinks"\).*\n)/.freeze
ACTIVE_STORAGE_REGEX = /(import.*ActiveStorage|require.*@rails\/activestorage.*)/.freeze
cable_config_path = Rails.root.join("config/cable.yml")

abort "❌ Webpacker not found. Exiting." unless defined?(Webpacker::Engine)

say "Install Turbo"
run "yarn add @hotwired/turbo-rails"
insert_into_file "#{Webpacker.config.source_entry_path}/application.js", "import \"@hotwired/turbo-rails\"\n", before: ACTIVE_STORAGE_REGEX

say "Remove Turbolinks"
run "#{RbConfig.ruby} bin/bundle remove turbolinks"
run "#{RbConfig.ruby} bin/bundle", capture: true
run "#{RbConfig.ruby} bin/yarn remove turbolinks"
gsub_file "#{Webpacker.config.source_entry_path}/application.js", TURBOLINKS_REGEX, ''
gsub_file "#{Webpacker.config.source_entry_path}/application.js", /Turbolinks.start.*\n/, ''

engine_root = defined?(ENGINE_ROOT) && Pathname.new(ENGINE_ROOT)
if engine_root
  say "Appending redis to Gemfile"
  append_to_file engine_root.join("Gemfile"), %(gem 'redis')

  say "Create config/cable.yml to use redis"
  create_file engine_root.join("config/cable.yml") do
    <<~FILE
      development:
        adapter: redis
        url: redis://localhost:6379/1

      test:
        adapter: test

      production:
        adapter: redis
        url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
        channel_prefix: dummy_production
    FILE
  end
else
  if cable_config_path.exist?
    say "Enable redis in bundle"
    uncomment_lines "Gemfile", %(gem 'redis')

    say "Switch development cable to use redis"
    gsub_file cable_config_path, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
  else
    say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
  end
end

say "Turbo successfully installed ⚡️", :green
