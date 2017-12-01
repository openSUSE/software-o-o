# Settings specified here will take precedence over those in config/environment.rb

SoftwareOO::Application.configure do
  config.cache_store = :compressed_mem_cache_store, 'localhost:11211', {:namespace => 'software-stage'}
end

CONFIG['use_static'] = "software.o.o-stage"
