source "https://rubygems.org"

ruby "3.0.0"

gem "rails", "~> 7.0.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "rspec-rails", "~> 5.0.0"
  gem "pry-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "dotenv-rails"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem "solargraph"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers', '~> 5.0'
end
