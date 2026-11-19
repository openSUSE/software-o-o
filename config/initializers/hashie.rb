Rails.application.configure do
  # OBS API access
  config.x = Hashie::Mash.new(config_for(:options))
end
