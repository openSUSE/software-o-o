# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)
require 'minitest/mock'
require 'digest'
require 'fileutils'

class PackageControllerTest < ActionDispatch::IntegrationTest
  UNKNOWN_PACKAGE_THUMBNAIL = Rails.root.join('public', 'images', 'thumbnails', 'SuperFancyBrowser.png')
  PKG_THUMBNAIL = Rails.root.join('public', 'images', 'thumbnails', 'armagetron.png')
  PKG_THUMBNAIL_RESIZED = Rails.root.join('test', 'support', '4Pane-600.png')

  setup do
    FileUtils.rm_f PKG_THUMBNAIL
  end

  teardown do
    FileUtils.rm_f PKG_THUMBNAIL
  end

  test 'thumbnail unknown package returns default asset' do
    FileUtils.rm_f UNKNOWN_PACKAGE_THUMBNAIL
    VCR.use_cassette('thumbnail unknown package returns default asset') do
      get '/package/thumbnail/SupperFancyBrowser.png?baseproject=ALL'
      assert_response :redirect
      assert_match %r{/assets/default-screenshots/package(.*).png}, @response.redirect_url
    end
  end

  test 'thumbnail downloaded uses it' do
    FileUtils.cp PKG_THUMBNAIL_RESIZED, PKG_THUMBNAIL

    VCR.use_cassette('thumbnail downloaded uses it') do
      get '/package/thumbnail/armagetron.png?baseproject=ALL'
      assert_redirected_to '/images/thumbnails/armagetron.png'
    end
  end

  test 'thumbnail not downloaded downloads it' do
    VCR.use_cassette('thumbnail not downloaded downloads it') do
      get '/package/thumbnail/armagetron.png?baseproject=ALL'
      assert_redirected_to '/images/thumbnails/armagetron.png'
      assert File.exist?(PKG_THUMBNAIL)
    end
  end

  test 'thumbnail failed download uses default image' do
    stub_request(:any, /armagetronad\.org/)
      .to_return(body: '', status: 404)

    VCR.use_cassette('thumbnail failed download uses default image') do
      get '/package/thumbnail/armagetron.png?baseproject=ALL'
      assert_response :redirect
      assert_match %r{/assets/default-screenshots/package(.*).png}, @response.redirect_url
      assert !File.exist?(PKG_THUMBNAIL)
    end
  end

  test 'known screenshot redirects to original' do
    VCR.use_cassette('known screenshot redirects to original') do
      get '/package/screenshot/armagetron.png?baseproject=ALL'
      assert_redirected_to 'http://armagetronad.org/screenshots/screenshot_2.png'
    end
  end

  test 'unknown screenshot is 404' do
    VCR.use_cassette('unknown screenshot is 404') do
      get '/package/screenshot/paralapapiricoipi.png?baseproject=ALL'
      assert_equal 404, status
    end
  end
end
