CONFIG['use_static'] = "software.o.o"

SoftwareOO::Application.configure do
  config.cache_store = :mem_cache_store, 'localhost:11211', {namespace: 'software', compress: true}
  config.log_level = :debug
end
