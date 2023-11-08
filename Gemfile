# frozen_string_literal: true

source 'https://rubygems.org'

# as framework
gem 'rails', '~> 7.0'

# as asset pipeline
gem 'sprockets-rails'

# as application server
gem 'puma'

# as templating engine
gem 'haml-rails', '~> 2.0'

# as database
gem 'pg'

# as logger
gem 'lograge'

# as scheduler
gem 'clockwork'

# for stylesheets
gem 'sassc-rails'

# as javascript asset compressor
gem 'terser'

# for translations
gem 'fast_gettext', '>= 2.2.0'
gem 'gettext_i18n_rails', '>= 1.8.1'
gem 'rails-i18n'

# as error catcher
gem 'sentry-rails'
gem 'sentry-ruby'

# for versioning
gem 'paper_trail'

gem 'dalli'
gem 'hashie'
gem 'mini_magick'
gem 'minitest'
gem 'nokogiri'
gem 'xmlhash', '>= 1.2.2'

gem 'matrix'
gem 'puma_worker_killer'

# FIXME: for selenium-webdriver, rexml isn't in the default set of Ruby 3.1 anymore
# see https://github.com/SeleniumHQ/selenium/commit/526fd9d0de60a53746ffa982feab985fed09a278
gem 'rexml'

# as HTTP client library
gem 'faraday'
gem 'faraday-decode_xml'
gem 'faraday-follow_redirects'
gem 'faraday-gzip'
gem 'faraday-http-cache'
gem 'faraday-mashify'
gem 'faraday-retry'

# as ActiveJob backend
gem 'delayed_job_active_record', '~> 4.1'

# needed to collect translatable strings
# not needed at production
group :development do
  # no need to load the gem via require
  # we only need the rake tasks
  gem 'gettext', '>= 3.4.2', require: false
  # as debugger
  gem 'pry'
  gem 'ruby_parser', require: false
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'geckodriver-bin', '~> 0.28.0'
  gem 'haml_lint', require: false
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'byebug'
end
