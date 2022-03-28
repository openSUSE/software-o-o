# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class DownloadControllerTest < ActionDispatch::IntegrationTest
  test 'download package returns a valid json document' do
    VCR.use_cassette('download package returns a valid json document') do
      get '/download/package.json?project=openSUSE%3ATools&package=osc'
      assert_response :success
      # Check if the schema is right
      json_item = JSON.parse(response.body).values.first
      assert_match %r{https://download.opensuse.org/repositories/openSUSE:Tools/(.*)/}, json_item['repo']
      # The key is filename, the value is link to that file on the server
      assert_match /osc(.*)/, json_item['package'].keys.first
      assert_match %r{https://download.opensuse.org/repositories/openSUSE:/Tools/(.*)/#{json_item['package'].keys.first}}, json_item['package'].values.first
    end
  end
end
