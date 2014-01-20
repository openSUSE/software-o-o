require 'test_helper'

class PackageInformationTest < ActionDispatch::IntegrationTest

  # Helper to associate queries to OBS with the corresponding file in
  # test/support
  def stub_remote_file(url, filename)
    %w(http https).each do |protocol|
      stub_request(:any, "#{protocol}://test:test@#{url}").to_return(body: File.read(Rails.root.join('test', 'support', filename)))
    end
  end

  def test_package_information
    # stub OBS using WebMock
    stub_remote_file("api.opensuse.org/public/distributions?", "distributions.xml")
    stub_remote_file("download.opensuse.org/factory/repo/oss/suse/setup/descr/appdata.xml.gz?", "appdata.xml.gz")
    stub_remote_file("download.opensuse.org/factory/repo/non-oss/suse/setup/descr/appdata.xml.gz?", "appdata-non-oss.xml.gz")
    stub_remote_file("api.opensuse.org/search/published/binary/id?match=@name%20=%20'pidgin'%20", "pidgin.xml")
    stub_remote_file("api.opensuse.org/published/openSUSE:13.1/standard/i586/pidgin-2.10.7-4.1.3.i586.rpm?view=fileinfo", "pidgin-fileinfo.xml")
    stub_request(:get, "https://test:test@api.opensuse.org/source/openSUSE:13.1/_attribute/OBS:QualityCategory").to_return(body: "<attributes/>")

    # Check that package information is displayed
    visit '/package/pidgin'
    assert page.has_content? 'Pidgin'
    assert page.has_content? 'InstantMessaging'
  end  
end

