source 'https://rubygems.org'

gem 'rails', '~> 3.2.1'
gem 'nokogiri'

gem 'gettext_i18n_rails', '>= 0.4.3'

# rails-i18n provides translations for ActiveRecord
# validation error messages
gem 'rails-i18n'

# needed to collect translatable strings
# not needed at production
group :development do
  # no need to load the gem via require
  # we only need the rake tasks
  gem 'gettext', '>= 1.9.3', :require => false
  gem 'thin'
end

gem 'mysql2'

gem 'delayed_job', '>3.0'
gem 'delayed_job_active_record'

gem 'xmlhash', '>= 1.2.2'

gem 'jquery-rails'

gem 'memcache-client'
gem 'sqlite3'
gem 'minitest', '~> 2.5'
gem 'hoptoad_notifier', "~> 2.3"

group :assets do
  gem 'sass-rails' # if running rails 3.1 or greater
  gem 'compass-rails'
  gem 'uglifier'
  # install nodejs instead!
  #gem 'therubyracer'
end

gem 'rake', '~> 0.9.2'
gem 'capistrano', '~> 2.13'
