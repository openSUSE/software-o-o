require File.expand_path('../../test_helper', __FILE__)
require 'faker'
require 'fileutils'

class ScreenshotTest < ActiveSupport::TestCase
  test 'Screenshot with nil url should return default screenshot' do
    pkg = Faker::Lorem.word
    screenshot = Screenshot.new(pkg, nil)
    assert_equal "default-screenshots/package.png", screenshot.thumbnail_path
  end

  test 'Screenshot with nil url but common name should return known default screenshot' do
    screenshot = Screenshot.new("#{Faker::Lorem.word}-devel", nil)
    assert_equal 'default-screenshots/devel-package.png', screenshot.thumbnail_path
  end

  test 'Screenshot should work' do
    pkg = Faker::Lorem.word
    screenshot = Screenshot.new(pkg, Rails.root.join('test', 'support', 'screenshot.png'))
    begin
      assert_equal "thumbnails/#{pkg}.png", screenshot.thumbnail_path
    ensure
      thumbnail_full_path = File.join(Rails.root, "public", "images", screenshot.thumbnail_path)
      FileUtils.rm_f thumbnail_full_path if File.exist?(thumbnail_full_path)
    end
  end
end
