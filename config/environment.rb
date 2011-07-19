# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '>=2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require "#{RAILS_ROOT}/lib/common/libxmlactivexml"

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  config.log_level = :debug

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options

  config.gem 'nokogiri'
  config.gem 'gettext_rails'
  config.gem 'gettext_activerecord'
  config.gem 'daemons'
  config.gem 'delayed_job'

  config.cache_store = :compressed_mem_cache_store, 'localhost:11211', {:namespace => 'software'}

end

# Include your application configuration below

ActionController::Base.relative_url_root = CONFIG['relative_url_root'] if CONFIG['relative_url_root']

# remove static cache files
%w{developer 112 113 114}.each { |release|
   FileUtils.rm_rf "#{RAILS_ROOT}/public/" + release
}

ActiveXML::Base.config do |conf|
  conf.setup_transport do |map|
    map.default_server :rest, API_HOST
    map.connect :project, 'rest:///source/:name/_meta',
      :all => 'rest:///source/'
    map.connect :package, 'rest:///source/:project/:name/_meta',
      :all => 'rest:///source/:project/'
    map.connect :pattern, 'rest:///source/:project/_pattern/:name',
      :all => 'rest:///source/:project/_pattern'
    map.connect :published,'rest:///published/:project/:repository/:arch/:name?:view'
    map.connect :seeker, 'rest:///search?match=:match',
      :project => 'rest:///search/project/id?match=:match',
      :package => 'rest:///search/package/id?match=:match',
      :pattern => 'rest:///search/published/pattern/id?match=:match',
      :binary => 'rest:///search/published/binary/id?match=:match'
  end
  conf.transport_for( :project ).set_additional_header( "X-Username", API_USERNAME)
  if defined? API_USERNAME && defined? API_PASSWORD && !API_PASSWORD.blank?
    conf.transport_for( :project ).login API_USERNAME, API_PASSWORD
  end
  conf.transport_for( :project ).set_additional_header( "User-Agent", "software.o.o" )
end

LANGUAGES = %w{en}
Dir.glob("#{RAILS_ROOT}/locale/*/LC_MESSAGES/software.mo").each { |file|
   lang = file.gsub(/^.*locale\/([^\/]*)\/.*$/, '\\1')
   lang = lang.gsub(/_/,'-')
   LANGUAGES << lang
}

LANGUAGE_NAMES = {'en' => 'English', 'de' => 'Deutsch', 'bg' => 'български', 'da' => 'dansk',
                  'cs' => 'čeština', 'es' => 'español', 'fi' => 'suomi', 'fr' => 'français',
                  'gl' => 'Galego', 'hu' => 'magyar', 'ja' => '日本語', 'it' => 'italiano',
                  'km' => 'ភាសាខ្មែរ', 'ko' => '한국어 [韓國語]', 'lt' => 'lietuvių kalba', 'nb' => 'Bokmål',
                  'nl' => 'Nederlands', 'pl' => 'polski', 'ro' => 'român', 'ru' => 'Русский язык',
                  'sk' => 'slovenčina', 'th' => 'ภาษาไทย', 'uk' => 'Українська', 'wa' => 'walon',
                  'pt-BR' => 'português', 'zh-TW' => '台語' }