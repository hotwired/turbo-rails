if (cable_config_path = Rails.root.join("config/cable.yml")).exist?
  say "Enable redis in bundle"

  gemfile_content = File.read(Rails.root.join("Gemfile"))
  pattern = /gem ['"]redis['"]/

  if gemfile_content.match?(pattern)
    uncomment_lines "Gemfile", pattern
  else
    append_file "Gemfile", "\n# Use Redis for Action Cable"
    gem 'redis', '~> 4.0'
  end

  run_bundle

  say "Switch development cable to use redis"
  gsub_file cable_config_path.to_s, /development:\n\s+adapter: async/, "development:\n  adapter: redis\n  url: redis://localhost:6379/1"
else
  say 'ActionCable config file (config/cable.yml) is missing. Uncomment "gem \'redis\'" in your Gemfile and create config/cable.yml to use the Turbo Streams broadcast feature.'
end
