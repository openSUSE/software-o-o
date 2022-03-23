# Load the Rails application.
require_relative "application"

GettextI18nRails.translations_are_html_safe = true

Rails.application.configure do
  # OBS API access
  config.x = Hashie::Mash.new(config_for(:options))
end

# Initialize the Rails application.
Rails.application.initialize!
