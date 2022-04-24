source "https://rubygems.org"

ruby "3.0.0"

gem "rails", "~> 7.0.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 3.10.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "httparty"
gem "devise"
gem "jwt"
gem "rack-cors"
gem "kaminari"
gem "aasm"
gem "rolify"
gem 'redis', '~>4.0'
gem 'aws-sdk-s3', '~> 1'

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
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma', require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers', '~> 5.0'
end
