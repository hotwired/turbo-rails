say "Appending Turbo setup code to #{Webpacker.config.source_entry_path}/application.js"
append_to_file "#{Webpacker.config.source_entry_path}/application.js", %(\nimport "@hotwired/turbo-rails"\n)

say "Install Turbo"
run "yarn add @hotwired/turbo-rails"

say "Run turbo:install:redis to switch on Redis and use it in development for turbo streams"