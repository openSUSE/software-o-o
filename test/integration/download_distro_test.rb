require 'test_helper'

class DownloadDistroTest < ActionDispatch::IntegrationTest

  def setup
    super
    visit '/'
    assert page.has_content? 'Download openSUSE'
  end

  def test_download_torrent
    choose 'BitTorrent'
    choose '64 Bit PC'
    click_button "download_button"
    assert_match /^http:\/\/download.*DVD-x86_64.iso.torrent$/, evaluate_script("mylink")
  end  

  def test_download_metalink
    find('#ci_gnome').click
    choose 'Metalink'
    choose 'i686'
    click_button "download_button"
    assert_match /^http:\/\/download.*GNOME-LiveCD-i686.iso.meta4$/, evaluate_script("mylink")
  end  

  def test_network_bittorrent
    # Choose kde BitTorrent download
    find('#ci_kde').click
    choose 'BitTorrent'
    assert has_checked_field?("p_torrent")
    assert has_no_checked_field?("p_http")
    assert_no_selector :xpath, "//input[@id='p_torrent'][@disabled='disabled']"
    # Change to network install, so BitTorrent should disable
    find('#ci_net').click
    assert has_no_checked_field?("p_torrent")
    assert has_checked_field?("p_http")
    assert_selector :xpath, "//input[@id='p_torrent'][@disabled='disabled']"
    # Choosing another option enables BitTorrent again
    find('#ci_dvd').click
    assert has_checked_field?("p_http")
    assert_no_selector :xpath, "//input[@id='p_torrent'][@disabled='disabled']"
  end

end

