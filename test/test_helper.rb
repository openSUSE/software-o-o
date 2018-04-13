require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist

require 'webmock/minitest'
# Prevent webmock to prevent capybara to connect to localhost
WebMock.disable_net_connect!(:allow_localhost => true)

class ActiveSupport::TestCase
  # Helper to associate queries to OBS with the corresponding file in
  # test/support
  def stub_content(url, what = {})
    what = { body: what } if what.is_a?(String)
    %w[http https].each do |protocol|
      stub = stub_request(:any, "#{protocol}://#{url}").to_return(what)
      stub.with(basic_auth: ['test', 'test']) if url =~ /^api/
    end
  end

  def stub_remote_file(url, filename)
    stub_content(url, body: File.read(Rails.root.join('test', 'support', filename)))
  end

  APPDATA_CHECKSUM = "a63a63d45b002d5ff8f37c09315cda2c4a9d89ae698f56e95b92f1274332c157".freeze
  APPDATA_NON_OSS_CHECKSUM = "be1fe70d7bf5a73e1e0e9e4a8bd6ea84c752bef85b02b2e7ea97cb4ac232d353".freeze

  setup do
    # stub OBS using WebMock
    stub_remote_file("api.opensuse.org/public/distributions?", "distributions.xml")
    stub_remote_file("download.opensuse.org/tumbleweed/repo/oss/repodata/repomd.xml", "repomd.xml")
    stub_remote_file("download.opensuse.org/tumbleweed/repo/non-oss/repodata/repomd.xml", "repomd-non-oss.xml")

    stub_remote_file("download.opensuse.org/tumbleweed/repo/oss/repodata/#{APPDATA_CHECKSUM}-appdata.xml.gz", "appdata.xml.gz")
    stub_remote_file("download.opensuse.org/tumbleweed/repo/non-oss/repodata/#{APPDATA_NON_OSS_CHECKSUM}-appdata.xml.gz", "appdata-non-oss.xml.gz")
    stub_remote_file("api.opensuse.org/search/published/binary/id?match=@name%20=%20'pidgin'%20", "pidgin.xml")
    stub_remote_file("api.opensuse.org/published/openSUSE:13.1/standard/i586/pidgin-2.10.7-4.1.3.i586.rpm?view=fileinfo", "pidgin-fileinfo.xml")
    stub_content("api.opensuse.org/source/openSUSE:13.1/_attribute/OBS:QualityCategory", "<attributes/>")
  end

  teardown do
    WebMock.reset!
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
