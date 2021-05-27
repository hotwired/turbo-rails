# Some Rails versions use commonJS(require) others use ESM(import).
TURBOLINKS_REGEX = /(import .* from "turbolinks".*\n|require\("turbolinks"\).*\n)/.freeze
ACTIVE_STORAGE_REGEX = /(import.*ActiveStorage|require.*@rails\/activestorage.*)/.freeze
CABLE_CONFIG_PATH = Rails.root.join("config/cable.yml")

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

if CABLE_CONFIG_PATH.exist?
  say "Enable redis in bundle"
  uncomment_lines "Gemfile", %(gem 'redis')

  say "Switch development cable to use redis"
  gsub_file CABLE_CONFIG_PATH.to_s, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
else
  say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
end

say "Turbo successfully installed ⚡️", :green
