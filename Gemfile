# frozen_string_literal: true

source 'https://rubygems.org'

gem 'nokogiri'
gem 'rails', '~> 7.0'

# Bug with psych breaks YAML loading, revert for now
gem 'psych', '< 4'

# For appdata redirections (https -> http)
gem 'open_uri_redirections'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

gem 'fast_gettext', '>= 2.2.0'
gem 'gettext_i18n_rails', '>= 1.8.1'

# rails-i18n provides translations for ActiveRecord
# validation error messages
gem 'rails-i18n'

gem 'dalli'
gem 'hashie'
gem 'mini_magick'
gem 'minitest'
gem 'xmlhash', '>= 1.3.7'

gem 'prometheus_exporter'
gem 'puma_worker_killer'

# HTTP client library for OBS Client
gem 'faraday'
gem 'faraday_middleware'
gem 'multi_xml'

# needed to collect translatable strings
# not needed at production
group :development do
  gem 'byebug'
  # no need to load the gem via require
  # we only need the rake tasks
  gem 'gettext', '>= 3.4.2', require: false
  gem 'solargraph'
  gem 'web-console'
end

group :production do
  gem 'puma'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'geckodriver-bin', '~> 0.28.0'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
end

# Debugging gems
# rbtrace does not install successfully in Docker and needs to be manually enabled
# gem 'rbtrace', require: false
