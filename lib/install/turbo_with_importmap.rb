say "Import Turbo"
append_to_file "app/javascript/application.js", %(import "@hotwired/turbo-rails"\n)

say "Pin Turbo"
append_to_file importmap_path.to_s, %(pin "@hotwired/turbo-rails", to: "turbo.js"\n)
