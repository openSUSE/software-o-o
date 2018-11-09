require File.expand_path('../../test_helper', __FILE__)
require 'api_connect'

class OBSControllerTest < ActionDispatch::IntegrationTest
  def test_backend_connection
    VCR.use_cassette('default') do
      get '/explore'

      assert_includes body, 'Search packages...'
      assert_equal 200, status
    end
  end

  def test_backend_error_handling
    mock = Minitest::Mock.new
    def mock.get
      raise Error
    end

    ApiConnect.stub :get, mock do
      # Otherwise the controller would get the distributions from cache
      Rails.cache.clear
      VCR.use_cassette('default') do
        get '/explore'
        assert_includes body, 'Connection to OBS is unavailable.'
        assert_equal 200, status
      end
    end
  end
end
