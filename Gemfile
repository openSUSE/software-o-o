source 'https://rubygems.org'

gem 'rails', '~> 4.2.8'
gem 'nokogiri'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
# With compass
gem 'compass-rails', '< 2.0'
gem 'compass', '< 1.0'
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

# needed to collect translatable strings
# not needed at production
group :development do
  # no need to load the gem via require
  # we only need the rake tasks
  gem 'gettext', '>= 1.9.3', :require => false
end

# MySQL is not used, as far as I know
gem 'mysql2', '~> 0.4.9'

gem 'xmlhash', '>= 1.2.2'

#gem 'memcache-client'
gem 'dalli'
gem 'sqlite3'
gem 'minitest'
gem 'hoptoad_notifier', "~> 2.3"
gem 'mini_magick'
#gem 'actionpack-page_caching'
#gem 'actionpack-action_caching'

group :test do
# This doesn't work because capybara-webkit (~> 1.1.1) depends on
# capybara (< 2.2.0, >= 2.0.2) ruby
#  gem 'capybara', '~>2.2.1'
#  gem 'capybara-webkit', '~>1.1.1'
# This 'bundles' but does not work (incompatibility)
#  gem 'capybara', '~>2.2.1'
#  gem 'capybara-webkit', '< 1.0'
# And this (the only working solution) cannot by installed because capybara-webkit (~> 1.1.1)
# requires 'websocket (~> 1.0.4)' but rubygem-websocket-1_0_7 requires ruby(abi) = 2.0.0
#  gem 'capybara', '~>2.0.3'
#  gem 'capybara-webkit', '~>1.1.1'
  gem 'capybara'
  gem 'poltergeist'

  gem 'webmock'
  
  gem 'rubocop', ">= 0.47"
end

# gem 'capistrano', '~> 2.13'
