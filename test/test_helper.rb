# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'faker'
require 'vcr'
require 'capybara/rails'
require 'webmock/minitest'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('test', 'support', 'vcr-cassettes')
  c.ignore_localhost = true
  c.hook_into :webmock
  username = Rails.configuration.x.api_username
  password = Rails.configuration.x.api_password
  c.filter_sensitive_data('<API USERNAME>') { username }
  c.filter_sensitive_data('<API HTTP AUTH>') { Base64.encode64("#{username}:#{password}").strip }
end

WebMock.disable_net_connect!(allow_localhost: true)

class ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_firefox, screen_size: [1400, 1400]
end

class ActiveSupport::TestCase
  setup do
    stub_request(:any, /-appdata\.xml\.gz/).to_return(body: File.new("#{Rails.root}/test/fixtures/appdata.xml.gz"), status: 200)
    stub_request(:any, /repomd\.xml/).to_return(body: File.new("#{Rails.root}/test/fixtures/repomd.xml"), status: 200)
  end
  teardown do
    WebMock.reset!
  end
end
