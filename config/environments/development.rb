SoftwareOO::Application.configure do
  config.cache_store = :memory_store
  # Do not eager load code on boot.
  config.eager_load = false
  config.assets.debug = true
  # Needed for generated thumbnails
  config.serve_static_files = true
end
