require File.expand_path('../../test_helper', __FILE__)

class PackageInformationTest < ActionDispatch::SystemTestCase
  def test_package_information
    VCR.use_cassette('default') do
      # Check that package information is displayed
      visit '/package/pidgin'
      page.assert_text 'Multiprotocol Instant Messaging Client'
      page.assert_text 'Pidgin is a chat program'
    end
  end
end
