SoftwareOO::Application.configure do
  config.cache_store = :memory_store
  # Do not eager load code on boot.
  config.eager_load = false
end

CONFIG['api_username'] = 'test'
CONFIG['api_password'] = 'test'
