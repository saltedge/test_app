source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.8"

gem "rails", "~> 6.1.4", ">= 6.1.4.1"
gem "pg", "~> 1.1"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "devise"
gem "carrierwave"
gem "bootstrap-sass"
gem "pry-byebug"
gem "pry-rails"
gem "rest-client"
gem "will_paginate", "~> 3.3"
gem "bootsnap", ">= 1.4.4", require: false
gem "unicorn", require: false
gem "settingslogic"
gem "airbrake", "~> 9"
gem 'rufus-scheduler'
gem 'nokogiri'

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 3.5"
  gem "factory_bot_rails"
  gem "capybara"
  gem "database_cleaner"
end

group :development do
  gem "web-console", ">= 4.1.0"
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  gem "spring"
end

group :test do
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "shoulda-matchers"
  gem "rails-controller-testing"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
