# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class SearchResultsTest < ActionDispatch::SystemTestCase
  def setup
    Capybara.reset_session!
  end

  def test_default_searches
    VCR.use_cassette('default') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:42.3"]').click
      end
      page.fill_in 'q', with: 'nvidia'
      page.find(:css, 'button#search-button').click
      page.assert_text 'for instructions how to configure your NVIDIA graphics card'
    end
  end

  def test_non_existing_packages
    #    VCR.use_cassette('search_paralapapiricoipi_openSUSE_Leap_42.3') do
    VCR.use_cassette('default') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:42.3"]').click
      end

      page.fill_in 'q', with: 'paralapapiricoipi'
      page.find(:css, 'button#search-button').click

      page.assert_text 'No packages found matching your search.'
    end
  end

  def test_only_version_query
    VCR.use_cassette('default') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:42.3"]').click
      end

      page.fill_in 'q', with: '1'
      page.find(:css, 'button#search-button').click

      page.assert_text 'The package name is required when searching for a version'
    end
  end

  def test_empty_query
    VCR.use_cassette('default') do
      visit '/explore'
      # There is no need to click on settings. If cookies are fresh, they will auto popup
      # if this ever changes, uncomment the next line
      # page.click_on 'Settings'
      within '#baseproject' do
        find('option[value="openSUSE:Leap:42.3"]').click
      end

      page.fill_in 'q', with: ''
      page.find(:css, 'button#search-button').click

      page.assert_text 'Please provide a valid search term'
    end
  end
end
