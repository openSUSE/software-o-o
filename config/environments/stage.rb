# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.action_controller.relative_url_root           = "/stage"

config.cache_store = :compressed_mem_cache_store, 'localhost:11211', {:namespace => 'software-stage'}

# Disable database access, if backend is not accessible
#config.frameworks -= [ :active_record ]

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

API_HOST = "https://api.opensuse.org"
# Add your username + password for the api here
API_USERNAME = "test"
API_PASSWORD = "test"

USE_STATIC = "software.o.o-stage"
