require File.expand_path('../../test_helper', __FILE__)

class PackageInformationTest < ActionDispatch::SystemTestCase
  def test_package_information
    # Check that package information is displayed
    visit '/package/pidgin'
    page.assert_text 'Multiprotocol Instant Messaging Client'
    page.assert_text 'Pidgin is a chat program'
  end
end
