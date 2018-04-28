source 'https://rubygems.org'

gem 'nokogiri'
gem 'rails', '~> 5.2'

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

# rails-i18n provides translations for ActiveRecord
# validation error messages
gem 'rails-i18n'

gem 'dalli'
gem 'hashie'
gem 'mini_magick'
gem 'minitest'
gem 'xmlhash', '>= 1.2.2'

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
  gem 'poltergeist'
  gem 'rubocop', "~> 0.49.0"
  gem 'webmock'
end

# Debugging gems
gem 'rbtrace', require: false
