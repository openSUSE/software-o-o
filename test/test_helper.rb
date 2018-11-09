require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'faker'
require 'vcr'

require 'capybara/rails'
class ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [1400, 1400]
end

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('test', 'support', 'vcr')
  c.default_cassette_options = { :record => :new_episodes }
  c.ignore_localhost = true
  c.filter_sensitive_data('<API USERNAME>') { Rails.configuration.x.api_username }
  c.filter_sensitive_data('<API HTTP AUTH>') { Base64.encode64("#{Rails.configuration.x.api_username}:#{Rails.configuration.x.api_password}").strip }
  c.hook_into :webmock
end
require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase
  teardown do
    WebMock.reset!
  end
end
