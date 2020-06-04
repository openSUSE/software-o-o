# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)
require 'minitest/mock'
require 'digest'
require 'fileutils'

class PackageControllerTest < ActionDispatch::IntegrationTest
  UNKNOWN_PACKAGE_THUMBNAIL = Rails.root.join('public', 'images', 'thumbnails', 'SuperFancyBrowser.png')
  PKG_4PANE_THUMBNAIL = Rails.root.join('public', 'images', 'thumbnails', '4pane.png')
  PKG_4PANE_THUMBNAIL_RESIZED = Rails.root.join('test', 'support', '4Pane-600.png')

  def test_thumbnail_unknown_package_returns_default_asset
    FileUtils.rm_f UNKNOWN_PACKAGE_THUMBNAIL
    VCR.use_cassette('default') do
      get '/package/thumbnail/SuperFancyBrowser.png'
      assert_response :redirect
      assert_match %r{/assets/default-screenshots/package(.*).png}, @response.redirect_url
    end
  end

  def test_thumbnail_downloaded_uses_it
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
    FileUtils.cp PKG_4PANE_THUMBNAIL_RESIZED, PKG_4PANE_THUMBNAIL

    VCR.use_cassette('default') do
      get '/package/thumbnail/4pane.png'
      assert_redirected_to '/images/thumbnails/4pane.png'
    end
  ensure
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
  end

  def test_thumbnail_not_downloaded_downloads_it
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
    VCR.use_cassette('default') do
      get '/package/thumbnail/4pane.png'
      assert_redirected_to '/images/thumbnails/4pane.png'
      assert File.exist?(PKG_4PANE_THUMBNAIL)
    end
  ensure
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
  end

  def test_thumbnail_failed_download_uses_default_image
    VCR.use_cassette('default') do
      stub_request(:any, 'http://www.4Pane.co.uk/4Pane624x351.png')
        .to_return(body: '', status: 404)
      FileUtils.rm_f PKG_4PANE_THUMBNAIL
      get '/package/thumbnail/4pane.png'
      assert_response :redirect
      assert_match %r{/assets/default-screenshots/package(.*).png}, @response.redirect_url
      assert !File.exist?(PKG_4PANE_THUMBNAIL)
    end
  end

  def test_known_screenshot_redirects_to_original
    VCR.use_cassette('default') do
      get '/package/screenshot/4pane.png'
      assert_redirected_to 'http://www.4Pane.co.uk/4Pane624x351.png'
    end
  end

  def test_unknown_screenshot_is_404
    VCR.use_cassette('default') do
      get '/package/screenshot/paralapapiricoipi.png'
      assert_equal 404, status
    end
  end
end
