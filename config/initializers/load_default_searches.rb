file=Rails.root.join("config", "default_searches.yml")
begin
  DEFAULT_SEARCHES = YAML.load_file(file)
rescue Exception => e
  puts "Error while parsing config file #{file}"
  raise e
end
