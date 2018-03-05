SoftwareOO::Application.configure do
  config.cache_store = :mem_cache_store, 'localhost:11211', {namespace: 'software', compress: true}

  # disabled until we figure the static.opensuse.org magic
  # config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.precompile += %w( jekyll.css main.js )
  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    log_level        = String(ENV['RAILS_LOG_LEVEL'] || "warn").upcase
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.level     = Logger.const_get(log_level)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
    config.log_level = log_level
  end
end
