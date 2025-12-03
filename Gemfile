# frozen_string_literal: true

def next?
  File.basename(__FILE__) == 'Gemfile.next'
end
# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.3'

# as framework
if next?
  gem 'rails', '~> 8.0'
else
  gem 'rails', '~> 7.2'
end
# as asset pipeline
gem 'sprockets-rails'
# as application server
gem 'puma'
# as templating engine
gem 'haml-rails', '~> 2.0'

# for appdata redirections (https -> http)
gem 'open_uri_redirections'

# for stylesheets
gem 'sassc-rails'

# as javascript asset compressor
gem 'terser'

# for translations
gem 'fast_gettext', '>= 2.2.0'
gem 'gettext_i18n_rails', '>= 1.8.1'
gem 'rails-i18n'

# for markdown in views
gem 'redcarpet', '~> 3.5.1'

# for logging
gem 'lograge'

# as error catcher
gem 'sentry-rails'
gem 'sentry-ruby'

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
gem 'faraday-net_http'
gem 'faraday-decode_xml'
gem 'faraday-follow_redirects'
gem 'faraday-gzip'
gem 'faraday-http-cache'
gem 'faraday-mashify'
gem 'faraday-retry'

# needed to collect translatable strings
# not needed at production
group :development do
  # no need to load the gem via require
  # we only need the rake tasks
  gem 'gettext', '>= 3.4.2', require: false
  gem 'ruby_parser', require: false
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'haml_lint', require: false
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-capybara'
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'pry'
  gem 'next_rails'
end

