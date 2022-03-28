# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class DownloadControllerTest < ActionDispatch::IntegrationTest
  test 'download package returns a valid json document' do
    VCR.use_cassette('download package returns a valid json document') do
      get '/download/package.json?project=openSUSE%3ATools&package=osc'
      assert_response :success
      # Check if the schema is right
      json_item = JSON.parse(response.body).values.first
      repo_link = 'https://download.opensuse.org/repositories'
      assert_match %r{#{repo_link}/openSUSE:Tools/(.*)/}, json_item['repo']
      # The key is filename, the value is link to that file on the server
      package_name = json_item['package'].keys.first
      package_link = json_item['package'].values.first
      assert_match(/osc(.*)/, package_name)
      assert_match %r{#{repo_link}/openSUSE:/Tools/(.*)/#{package_name}}, package_link
    end
  end
end
