require File.expand_path('../../test_helper', __FILE__)

class PackageInformationTest < ActionDispatch::IntegrationTest

  def test_package_information
    # Check that package information is displayed
    visit '/package/pidgin'
    assert page.has_content? 'Multiprotocol Instant Messaging Client'
    assert page.has_content? 'Pidgin is a chat program'
  end
end
