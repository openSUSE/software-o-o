source 'https://rubygems.org'

gem 'compass-rails', '~> 3.0.2'
gem 'dalli'
gem 'fast_gettext', '>= 0.7.0'
gem 'gettext_i18n_rails', '>= 0.4.3'
gem 'hashie'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 4.2.1'
gem 'mini_magick'
gem 'minitest'
gem 'nokogiri'
gem 'rails', '~> 5.1.4'
gem 'rails-i18n' # translations for ActiveRecord validation error messages
gem 'sass-rails', '~> 5.0.7' # CSS preprocessor
gem 'uglifier', '>= 1.3.0' # JavaScript compressor
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
  gem 'rubocop', ">= 0.47"
  gem 'webmock'
end
