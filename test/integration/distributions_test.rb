require File.expand_path('../../test_helper', __FILE__)

class DistributionsTest < ActionDispatch::IntegrationTest
  def test_distribution_redirection
    VCR.use_cassette('default') do
      travel_to Time.parse('2018-05-17 00:00:00') do
        get '/distributions/leap'
        assert_includes body, 'openSUSE Leap 42.3'
        assert_includes body, 'Choosing Which Media to Download'
        assert_match %r{assets\/distributions\/leap(.*)\.svg}, body
        assert_equal 200, status

        get '/distributions/testing'
        assert_includes body, 'openSUSE Leap 15.0'
        assert_match %r{assets\/distributions\/testing(.*)\.svg}, body

        assert_equal 200, status
      end
    end

    ['2018-05-25 13:00:00 CET', '2018-05-25 12:00:00 UTC'].each do |date|
      VCR.use_cassette('default') do
        travel_to Time.parse(date) do
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
  end

  def test_versioned_leap_testing
    VCR.use_cassette('default') do
      travel_to Time.parse('2018-05-25 11:00:00 UTC') do
        get '/distributions/leap/15_0'
        assert_match %r{assets\/distributions\/testing(.*)\.svg}, body
      end
    end
  end

  def test_versioned_leap_stable
    VCR.use_cassette('default') do
      travel_to Time.parse('2018-05-25 13:00:00 UTC') do
        Rails.cache.delete('software-o-o/releases')
        get '/distributions/leap/15_0'
        assert_match %r{assets\/distributions\/leap(.*)\.svg}, body
      end
    end
  end

  def test_versioned_leap_legacy
    VCR.use_cassette('default') do
      travel_to Time.parse('2018-05-25 13:00:00 UTC') do
        Rails.cache.delete('software-o-o/releases')
        get '/distributions/leap/42_3'
        assert_match %r{assets\/distributions\/leap(.*)\.svg}, body
      end
    end
  end

  def test_legacy_route
    VCR.use_cassette('default') do
      travel_to Time.parse('2018-05-25 13:00:00 UTC') do
        Rails.cache.delete('software-o-o/releases')
        get '/distributions/leap/legacy'
        assert_match %r{assets\/distributions\/leap(.*)\.svg}, body
        assert_includes body, 'openSUSE Leap 42.3'
      end
    end
  end

  def test_testing_route
    VCR.use_cassette('default') do
      travel_to Time.parse('2019-05-01 13:00:00 UTC') do
        Rails.cache.delete('software-o-o/releases')
        get '/distributions/testing'
        assert_match %r{assets\/distributions\/testing(.*)\.svg}, body
        assert_includes body, 'openSUSE Leap 15.1'
      end
    end
  end
end
