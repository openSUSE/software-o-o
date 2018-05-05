require File.expand_path('../../test_helper', __FILE__)

class ValidateConfigurationTest < ActionDispatch::IntegrationTest
  def test_validate_configuration
    # Fake that authentication is not configured
    x = Rails.configuration.x.clone
    Rails.configuration.x.api_username = nil
    Rails.configuration.x.opensuse_cookie = nil

    get '/'
    assert_includes body, 'The authentication to the OBS API has not been configured correctly.'
    assert_equal 503, status

    # Restore normal configuration values for other tests
    Rails.configuration.x = x
  end
end
