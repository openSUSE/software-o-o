require File.expand_path('../../test_helper', __FILE__)
require 'minitest/mock'
require 'digest'
require 'fileutils'

class PackageControllerTest < ActionDispatch::IntegrationTest
  FIREFOX_THUMBNAIL = File.join(Rails.root, 'public', 'images', 'thumbnails', 'MozillaFirefox.png')
  PKG_4PANE_THUMBNAIL = File.join(Rails.root, 'public', 'images', 'thumbnails', '4pane.png')

  def test_thumbnail_unknown_package_returns_default_asset
    stub = proc { |arg| arg == FIREFOX_THUMBNAIL ? false : File.exist?(arg) }

    File.stub(:exists?, stub) do
      get '/package/thumbnail/MozillaFirefox.png'
      assert_redirected_to '/assets/default-screenshots/package.png'
    end
  end

  def test_thumbnail_downloaded_uses_it
    stub = proc { |arg| arg == PKG_4PANE_THUMBNAIL ? true : File.exist?(arg) }
    File.stub(:exists?, stub) do
      get '/package/thumbnail/4pane.png'
      assert_redirected_to '/images/thumbnails/4pane.png'
    end
  end

  def test_thumbnail_not_downloaded_downloads_it
    stub_remote_file('http://www.4Pane.co.uk/4Pane624x351.png', '4Pane624x351.png')
    # Stub exists? would not work here, as it downloads and checks again for existence
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
    get '/package/thumbnail/4pane.png'
    assert_redirected_to '/images/thumbnails/4pane.png'
    assert File.exist?(PKG_4PANE_THUMBNAIL)
  end

  def test_thumbnail_failed_download_uses_default_image
    stub_request(:any, 'http://www.4Pane.co.uk/4Pane624x351.png')
      .to_return(body: '', status: 404)
    # Stub exists? would not work here
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
    get '/package/thumbnail/4pane.png'
    assert_redirected_to '/assets/default-screenshots/package.png'
    assert !File.exist?(PKG_4PANE_THUMBNAIL)
  end

  def test_known_screenshot_redirects_to_original
    get '/package/screenshot/4pane.png'
    assert_redirected_to 'http://www.4Pane.co.uk/4Pane624x351.png'
  end

  def test_unknown_screenshot_is_404
    get '/package/screenshot/paralapapiricoipi.png'
    assert_equal 404, status
  end
end
