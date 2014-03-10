SoftwareOO::Application.configure do
  config.cache_store = :memory_store
  # Do not eager load code on boot.
  config.eager_load = false
end

if defined? CONFIG
  # Add your username + password for the api here
  CONFIG['api_username'] = "wiki_hermes"
  CONFIG['api_password'] = "w_h_p1"
end
