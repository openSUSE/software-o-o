source 'https://rubygems.org'

gem 'rails', '~> 4.2.8'
gem 'nokogiri'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
# With compass
gem 'compass-rails', '~> 2.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 4.2.1'

gem 'gettext_i18n_rails', '>= 0.4.3'
gem 'fast_gettext', '>= 0.7.0'

# rails-i18n provides translations for ActiveRecord
# validation error messages
gem 'rails-i18n'

gem 'xmlhash', '>= 1.2.2'
gem 'hashie'
gem 'dalli'
gem 'minitest'
gem 'hoptoad_notifier', "~> 2.3"
gem 'mini_magick'

# needed to collect translatable strings
# not needed at production
group :development do
  # no need to load the gem via require
  # we only need the rake tasks
  gem 'gettext', '>= 1.9.3', :require => false
end

group :production do
  gem 'puma'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'webmock'
  gem 'rubocop', ">= 0.47"
end
