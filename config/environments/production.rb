CONFIG['use_static'] = "software.o.o"

SoftwareOO::Application.configure do
  config.cache_store = :mem_cache_store, 'localhost:11211', {namespace: 'software', compress: true}
  config.log_level = :debug

  config.serve_static_assets = false

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

end
