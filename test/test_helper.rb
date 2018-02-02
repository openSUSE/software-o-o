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
  def stub_remote_file(url, filename)
    %w[http https].each do |protocol|
      stub = stub_request(:any, "#{protocol}://#{url}").to_return(body: File.read(Rails.root.join('test', 'support', filename)))
      stub.with(basic_auth: ['test', 'test']) if url =~ /^api/
    end
  end

  setup do
    # stub OBS using WebMock
    stub_remote_file("api.opensuse.org/public/distributions?", "distributions.xml")
    stub_remote_file("download.opensuse.org/tumbleweed/repo/oss/suse/setup/descr/appdata.xml.gz", "appdata.xml.gz")
    stub_remote_file("download.opensuse.org/tumbleweed/repo/non-oss/suse/setup/descr/appdata.xml.gz", "appdata-non-oss.xml.gz")
    stub_remote_file("api.opensuse.org/search/published/binary/id?match=@name%20=%20'pidgin'%20", "pidgin.xml")
    stub_remote_file("api.opensuse.org/published/openSUSE:13.1/standard/i586/pidgin-2.10.7-4.1.3.i586.rpm?view=fileinfo", "pidgin-fileinfo.xml")
    stub_request(:get, "https://test:test@api.opensuse.org/source/openSUSE:13.1/_attribute/OBS:QualityCategory").to_return(body: "<attributes/>")
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
