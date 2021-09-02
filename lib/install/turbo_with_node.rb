say "Import Turbo"
append_to_file "app/javascript/application.js", %(import "@hotwired/turbo-rails"\n)

say "Install Turbo"
run "npm i @hotwired/turbo-rails"
