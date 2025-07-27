source "https://rubygems.org"

gem "rails", "~> 8.0"
gem "propshaft" # The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "sqlite3", ">= 2.1" # Use sqlite3 as the database for Active Record
gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]
gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "tailwindcss-rails" # Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "solid_cache", "~> 1.0" # Use the database-backed adapter for Rails.cache
gem "solid_queue", "~> 1.1" # Use the database-backed adapter for Active Job
gem "solid_cable", "~> 3.0" # Use the database-backed adapter for Action Cable

group :development, :test do
  gem "debug", platforms: [:mri, :windows], require: "debug/prelude" # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "brakeman", require: false # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "rubocop-shopify", "~> 2.17", require: false
  gem "erb_lint", "~> 0.9.0", require: false
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails", "~> 6.5"
  gem "i18n-tasks", "~> 1.0"
end

group :development do
  gem "web-console" # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :test do
  gem "capybara" # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.0"
  gem "database_cleaner-active_record", "~> 2.1"
  gem "rails-controller-testing", "~> 1.0"
end
