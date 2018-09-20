source 'https://rubygems.org'

gem 'nokogiri'
gem 'rails', '~> 5.2'

# For appdata redirections (https -> http)
gem 'open_uri_redirections'
# Use SCSS for stylesheets
gem 'sass-rails'
# With compass
gem 'compass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'fast_gettext', '>= 0.7.0'
gem 'gettext_i18n_rails', '>= 0.4.3'

gem 'opensuse_theme_chameleon-rails', git: 'https://github.com/openSUSE/opensuse_theme_chameleon-rails', submodules: true, branch: 'master'

# rails-i18n provides translations for ActiveRecord
# validation error messages
gem 'rails-i18n'

gem 'dalli'
gem 'hashie'
gem 'mini_magick'
gem 'minitest'
gem 'xmlhash', '>= 1.2.2'

gem 'prometheus_exporter'
gem 'puma_worker_killer'

# needed to collect translatable strings
# not needed at production
group :development do
  # no need to load the gem via require
  # we only need the rake tasks
  gem 'gettext', '>= 1.9.3', require: false
end

group :production do
  gem 'puma'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'geckodriver-helper'
  gem 'rubocop'
  gem 'selenium-webdriver'
  gem 'webmock'
end

# Debugging gems
# rbtrace does not install successfully in Docker and needs to be manually enabled
# gem 'rbtrace', require: false
