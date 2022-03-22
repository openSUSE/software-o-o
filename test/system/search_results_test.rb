# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class SearchResultsTest < ActionDispatch::SystemTestCase
  def setup
    Capybara.reset_session!
  end

  test 'default searches' do
    VCR.use_cassette('default searches') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:15.2"]').click
      end
      page.fill_in 'q', with: 'nvidia'
      page.find(:css, 'button#search-button').click
      page.assert_text 'for instructions how to configure your NVIDIA graphics card'
    end
  end

  test 'non existing packages' do
    VCR.use_cassette('non existing packages') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:15.2"]').click
      end

      page.fill_in 'q', with: 'paralapapiricoipi'
      page.find(:css, 'button#search-button').click

      page.assert_text 'No packages found matching your search.'
    end
  end

  test 'only version query' do
    VCR.use_cassette('only version query') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:15.2"]').click
      end

      page.fill_in 'q', with: '1'
      page.find(:css, 'button#search-button').click

      page.assert_text 'The package name is required when searching for a version'
    end
  end

  test 'empty query' do
    VCR.use_cassette('empty query') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:15.2"]').click
      end

      page.fill_in 'q', with: ''
      page.find(:css, 'button#search-button').click

      page.assert_text 'Please provide a valid search term'
    end
  end
end
