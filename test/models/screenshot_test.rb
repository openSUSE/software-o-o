require File.expand_path('../../test_helper', __FILE__)
require 'faker'
require 'fileutils'
require 'mini_magick'

class ScreenshotTest < ActiveSupport::TestCase
  test 'Screenshot with nil url should return default screenshot' do
    pkg = Faker::Lorem.word
    screenshot = Screenshot.new(pkg, nil)
    assert_equal "assets/default-screenshots/package.png", screenshot.thumbnail_path
  end

  test 'Screenshot with nil url but common name should return known default screenshot' do
    screenshot = Screenshot.new("#{Faker::Lorem.word}-devel", nil)
    assert_equal 'assets/default-screenshots/devel-package.png', screenshot.thumbnail_path
  end

  test 'Screenshot should be able to get a correct thumbnail' do
    pkg = Faker::Lorem.word
    screenshot = Screenshot.new(pkg, Rails.root.join('test', 'support', 'screenshot.png'))
    begin
      thumbnail_full_path = File.join(Rails.root, "public", screenshot.thumbnail_path)
      assert_equal "images/thumbnails/#{pkg}.png", screenshot.thumbnail_path
      image = MiniMagick::Image.open(thumbnail_full_path)
      assert_equal 600, image.width
    ensure
      FileUtils.rm_f thumbnail_full_path if File.exist?(thumbnail_full_path)
    end
  end
end
