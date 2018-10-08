require File.expand_path('../../test_helper', __FILE__)

class SearchResultsTest < ActionDispatch::SystemTestCase

  def setup
    Capybara.reset_session!
  end

  def test_default_searches
    stub_search_random('nvidia', 'openSUSE:Leap:42.3')
    visit '/'
    # There is no need to click on settings. If cookies are fresh, they will auto popup
    # if this ever changes, uncomment the next line
    # page.click_on 'Settings'
    within '#search-settings' do
      find('option[value="openSUSE:Leap:42.3"]').click
      click_on 'OK'
    end
    page.fill_in 'q', with: 'nvidia'
    page.find(:css, 'button#search-button').click

    page.assert_text 'for instructions how to configure your NVIDIA graphics card'
  end

  def test_non_existing_packages
    stub_search_random('paralapapiricoipi', 'openSUSE:Leap:42.3', matches: 0)
    visit '/'
    # There is no need to click on settings. If cookies are fresh, they will auto popup
    # if this ever changes, uncomment the next line
    # page.click_on 'Settings'
    within '#search-settings' do
      find('option[value="openSUSE:Leap:42.3"]').click
      page.click_on 'OK'
    end

    page.fill_in 'q', with: 'paralapapiricoipi'
    page.find(:css, 'button#search-button').click

    page.assert_text 'No packages found matching your search.'
  end
end
