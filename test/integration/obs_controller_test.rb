# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)
require 'api_connect'

class OBSControllerTest < ActionDispatch::IntegrationTest
  test 'backend_connection' do
    VCR.use_cassette('backend connection') do
      get '/explore'

      assert_includes body, 'Search packages...'
      assert_equal 200, status
    end
  end

  test 'backend error handling' do
    mock = Minitest::Mock.new
    def mock.get
      raise Error
    end

    ApiConnect.stub :get, mock do
      # Otherwise the controller would get the distributions from cache
      Rails.cache.clear
      VCR.use_cassette('backend error handling') do
        get '/explore'
        assert_includes body, 'Connection to OBS is unavailable.'
        assert_equal 200, status
      end
    end
  end
end
