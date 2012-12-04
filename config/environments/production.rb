CONFIG['use_static'] = "software.o.o"

SoftwareOO::Application.configure do
  config.cache_store = :mem_cache_store, 'localhost:11211', {namespace: 'software', compress: true}
  config.log_level = :debug

  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true
end
