APP_JS_ROOT = Rails.root.join("app/assets/javascripts")
CABLE_CONFIG_PATH = Rails.root.join("config/cable.yml")

say "Import turbo-rails in existing app/assets/javascripts/application.js"
append_to_file APP_JS_ROOT.join("application.js"), %(import "@hotwired/turbo-rails"\n)

if CABLE_CONFIG_PATH.exist?
  say "Enable redis in bundle"
  uncomment_lines "Gemfile", %(gem 'redis')

  say "Switch development cable to use redis"
  gsub_file CABLE_CONFIG_PATH.to_s, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
else
  say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
end
