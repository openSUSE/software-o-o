# frozen_string_literal: true

source 'https://rubygems.org'

gem 'nokogiri'
gem 'rails', '~> 5.2'

# For appdata redirections (https -> http)
gem 'open_uri_redirections'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

gem 'fast_gettext', '>= 0.7.0'
gem 'gettext_i18n_rails', '>= 0.4.3'

# rails-i18n provides translations for ActiveRecord
# validation error messages
gem 'rails-i18n'

# Generate html based on markdown in views
gem 'redcarpet', '~> 3.4.0'

gem 'dalli'
gem 'hashie'
gem 'mini_magick'
gem 'minitest'
gem 'xmlhash', '>= 1.2.2'

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
  gem 'gettext', '>= 1.9.3', require: false
  gem 'solargraph'
  gem 'web-console'
end

group :production do
  gem 'puma'
end

group :test do
  gem 'capybara'
  gem 'faker'
  # bragboy's fork works with Firefox 80
  # ', git:...' can be removed once https://github.com/DevicoSolutions/geckodriver-helper/pull/17
  # is merged and a new gem version is released
  gem 'geckodriver-helper', git: 'https://github.com/bragboy/geckodriver-helper'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
end

# Debugging gems
# rbtrace does not install successfully in Docker and needs to be manually enabled
# gem 'rbtrace', require: false
