ENV["RAILS_ENV"] = "test"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
Capybara.default_driver = :webkit

require 'webmock/test_unit'
# Prevent webmock to prevent capybara to connect to localhost
WebMock.disable_net_connect!(:allow_localhost => true)

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
