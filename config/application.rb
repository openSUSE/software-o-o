require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module SoftwareOO
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = true
    config.gettext_i18n_rails.default_options = %w[--sort-by-msgid]
    config.gettext_i18n_rails.msgmerge_options = %w[--add-location --quiet]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Skip frameworks you're not going to use
    #config.frameworks -= [ :action_web_service, :active_resource ]

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{Rails.root}/extras )

    # Rails.root is not working directory when running under lighttpd, so it has
    # to be added to load path
    #config.load_paths << Rails.root unless config.load_paths.include? Rails.root
    
    # Force all environments to use the same logger level 
    # (by default production uses :info, the others :debug)
    # config.log_level = :debug
    
    # Use the database for sessions instead of the file system
    # (create the session table with 'rake create_sessions_table')
    # config.action_controller.session_store = :active_record_store
        
    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector
    
    # Make Active Record use UTC-base instead of local time
    # config.active_record.default_timezone = :utc
    
    config.action_controller.perform_caching = true

    config.exceptions_app = self.routes

    config.generators do |g|
      g.template_engine :haml
    end

    # See Rails::Configuration for more options
    config.after_initialize do
     # ExceptionNotifier.exception_recipients = CONFIG["exception_recipients"]
     # ExceptionNotifier.sender_address = CONFIG["exception_sender"]
    end unless Rails.env.test?

    config.active_support.deprecation = :log
  end
end
