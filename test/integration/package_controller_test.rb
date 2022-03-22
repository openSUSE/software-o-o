# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)
require 'minitest/mock'
require 'digest'
require 'fileutils'

class PackageControllerTest < ActionDispatch::IntegrationTest
  UNKNOWN_PACKAGE_THUMBNAIL = Rails.root.join('public', 'images', 'thumbnails', 'SuperFancyBrowser.png')
  PKG_4PANE_THUMBNAIL = Rails.root.join('public', 'images', 'thumbnails', '4pane.png')
  PKG_4PANE_THUMBNAIL_RESIZED = Rails.root.join('test', 'support', '4Pane-600.png')

  test 'thumbnail unknown package returns default asset' do
    FileUtils.rm_f UNKNOWN_PACKAGE_THUMBNAIL
    VCR.use_cassette('thumbnail unknown package returns default asset') do
      get '/package/thumbnail/SupperFancyBrowser.png?baseproject=ALL'
      assert_response :redirect
      assert_match %r{/assets/default-screenshots/package(.*).png}, @response.redirect_url
    end
  end

  test 'thumbnail downloaded uses it' do
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
    FileUtils.cp PKG_4PANE_THUMBNAIL_RESIZED, PKG_4PANE_THUMBNAIL

    VCR.use_cassette('thumbnail downloaded uses it') do
      get '/package/thumbnail/4pane.png?baseproject=ALL'
      assert_redirected_to '/images/thumbnails/4pane.png'
    end
  ensure
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
  end

  test 'thumbnail not downloaded downloads it' do
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
    VCR.use_cassette('thumbnail not downloaded downloads it') do
      get '/package/thumbnail/4pane.png?baseproject=ALL'
      assert_redirected_to '/images/thumbnails/4pane.png'
      assert File.exist?(PKG_4PANE_THUMBNAIL)
    end
  ensure
    FileUtils.rm_f PKG_4PANE_THUMBNAIL
  end

  test 'thumbnail failed download uses default image' do
    VCR.use_cassette('thumbnail failed download uses default image') do
      stub_request(:any, 'http://www.4Pane.co.uk/4Pane624x351.png')
        .to_return(body: '', status: 404)
      FileUtils.rm_f PKG_4PANE_THUMBNAIL
      get '/package/thumbnail/4pane.png?baseproject=ALL'
      assert_response :redirect
      assert_match %r{/assets/default-screenshots/package(.*).png}, @response.redirect_url
      assert !File.exist?(PKG_4PANE_THUMBNAIL)
    end
  end

  test 'known screenshot redirects to original' do
    VCR.use_cassette('known screenshot redirects to original') do
      get '/package/screenshot/4pane.png?baseproject=ALL'
      assert_redirected_to 'http://www.4Pane.co.uk/4Pane624x351.png'
    end
  end

  test 'unknown screenshot is 404' do
    VCR.use_cassette('unknown screenshot is 404') do
      get '/package/screenshot/paralapapiricoipi.png?baseproject=ALL'
      assert_equal 404, status
    end
  end
end
