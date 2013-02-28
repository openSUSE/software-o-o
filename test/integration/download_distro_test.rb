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
end

