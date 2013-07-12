source 'https://rubygems.org'

gem 'rails', '~> 3.2.1'
gem 'nokogiri'

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

gem 'mysql2'

gem 'delayed_job', '>3.0'
gem 'delayed_job_active_record'

gem 'xmlhash', '>= 1.2.2'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'memcache-client'
gem 'sqlite3'
gem 'minitest'
gem 'hoptoad_notifier', "~> 2.3"

group :assets do
  gem 'sass-rails' # if running rails 3.1 or greater
  gem 'compass-rails'
  gem 'uglifier'
  # install nodejs instead!
  #gem 'therubyracer'
end

group :test do
  gem 'capybara', '~>2.0.1'
  gem 'capybara-webkit', '< 1.0'
end

gem 'capistrano', '~> 2.13'
