if (js_entrypoint_path = Rails.root.join("app/javascript/application.js")).exist?
  say "Import Turbo"
  append_to_file "app/javascript/application.js", %(import "@hotwired/turbo-rails"\n)
else
  say %(For Rails 6, add "import '@hotwired/turbo-rails'" to "app/javascript/packs/application.js"), :red
end

say "Install Turbo"
run "yarn add @hotwired/turbo-rails"
