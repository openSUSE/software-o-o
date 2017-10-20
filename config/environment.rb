# Load the rails application
require File.expand_path('../application', __FILE__)
GettextI18nRails.translations_are_html_safe = true

SoftwareOO::Application.configure do
  # OBS API access
  config.x = Hashie::Mash.new(config_for(:options))
end

# Initialize the rails application
SoftwareOO::Application.initialize!
