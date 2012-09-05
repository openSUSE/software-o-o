# Be sure to restart your web server when you modify this file.

# Load the rails application
require File.expand_path('../application', __FILE__)

path = Rails.root.join("config", "options.yml")

begin
  CONFIG = YAML.load_file(path)
rescue Exception => e
  puts "Error while parsing config file #{path}"
  CONFIG = Hash.new
end

GettextI18nRails.translations_are_html_safe = true

# Initialize the rails application
SoftwareOO::Application.initialize!

