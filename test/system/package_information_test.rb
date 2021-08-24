# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class PackageInformationTest < ActionDispatch::SystemTestCase
  def test_package_information
    VCR.use_cassette('default') do
      # Check that package information is displayed
      visit '/package/pidgin?baseproject=ALL'
      page.assert_text 'Multiprotocol Instant Messaging Client'
      page.assert_text 'Pidgin is a messaging application which lets you log in to accounts'
    end
  end
end
