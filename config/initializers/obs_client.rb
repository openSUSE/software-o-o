require 'obs'

config = Rails.configuration.x

OBS.configure do |obs|
  obs.api_host = config.api_host
  obs.api_username = config.api_username
  obs.api_password = config.api_password
end
