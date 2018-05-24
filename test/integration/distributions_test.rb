require File.expand_path('../../test_helper', __FILE__)

class DistributionsTest < ActionDispatch::IntegrationTest
  def test_distribution_redirection
    travel_to Time.parse('2018-05-17 00:00:00') do
      get '/distributions/leap'
      assert_includes body, 'openSUSE Leap 42.3'
      assert_includes body, 'Choosing Which Media to Download'
      assert_match %r{assets\/distributions\/leap(.*)\.svg}, body
      assert_equal 200, status

      get '/distributions/testing'
      assert_includes body, 'openSUSE Leap 15.0'
      assert_includes body, 'Help test the next version of openSUSE Leap!'
      assert_match %r{assets\/distributions\/testing(.*)\.svg}, body

      assert_equal 200, status
    end

    travel_to Time.parse('2018-05-25 11:00:00') do
      Rails.cache.delete('software-o-o/releases')

      get '/distributions/leap'
      assert_includes body, 'openSUSE Leap 15.0'
      assert_includes body, 'Choosing Which Media to Download'
      assert_match %r{assets\/distributions\/leap(.*)\.svg}, body

      assert_equal 200, status

      get '/distributions/testing'
      assert_redirected_to '/distributions/leap'
      assert_includes flash[:error], 'No testing distribution available'
      assert_equal 302, status
    end
  end
end
