# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rake', '~> 13.0'

# PRESENTATION LAYER
gem 'slim', '~> 4.1'

# APPLICATION LAYER
# Web Application
gem 'puma', '~> 5'
gem 'rack-session', '~> 0.3'
gem 'roda', '~> 3'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# DOMAIN LAYER
# Validation
gem 'dry-struct', '~> 1'
gem 'dry-types', '~> 1'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5'

# Database
# gem 'hirb', '~> 0'
# gem 'hirb-unicode', '~> 0'
# gem 'unicode-display_width' ,'~> 1.5'
gem 'sequel', '~> 5.49'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

group :production do
  gem 'pg', '~> 1.2'
end

# Testing
group :test do
  gem 'minitest', '~> 5'
  gem 'minitest-rg', '~> 5'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6.0'
  gem 'webmock', '~> 3.0'

  gem 'headless', '~> 2.3'
  gem 'page-object', '~> 2.3'
  gem 'watir', '~> 7.0'
  gem 'webdrivers', '~> 5.0'
end

group :development do
  gem 'rerun', '~> 0'
end

# Debugging
gem 'pry'

# Code Quality
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop', '~> 1.39', require: false
end

# Parsing
gem 'geocoder'
gem 'json'

# Stat feature
gem 'descriptive_statistics'
gem 'rover-df'

# Asynchronicity
gem 'concurrent-ruby', '~> 1.1'
gem 'aws-sdk-sqs', '~> 1.48'

# WORKER
gem 'shoryuken', '~> 5.3'
gem 'faye', '~> 1.4'
