if (cable_config_path = Rails.root.join("config/cable.yml")).exist?
  say "Enable redis in bundle"
  uncomment_lines "Gemfile", /gem ['"]redis['"]/

  say "Switch development cable to use redis"
  gsub_file cable_config_path.to_s, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
else
  say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
end
