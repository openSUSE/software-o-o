require 'test_helper'

class PackageInformationTest < ActionDispatch::IntegrationTest

  def test_package_information
    # Check that package information is displayed
    visit '/package/pidgin'
    assert page.has_content? 'Pidgin'
    assert page.has_content? 'InstantMessaging'
  end
end
