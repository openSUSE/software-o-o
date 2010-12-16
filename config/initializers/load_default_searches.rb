begin
  DEFAULT_SEARCHES = YAML.load_file("#{RAILS_ROOT}/config/default_searches.yml")
rescue Exception => e
  puts "Error while parsing config file #{RAILS_ROOT}/config/default_searches.yml"
  raise e
end
