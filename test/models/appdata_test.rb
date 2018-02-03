require File.expand_path('../../test_helper', __FILE__)

class AppdataTest < ActiveSupport::TestCase
  test 'Factory Appdata can be parsed' do
    appdata = Appdata.get('factory')
    pkg_list = appdata[:apps].map { |p| p[:pkgname] }.uniq

    assert_equal 4, pkg_list.size
    assert_equal ['0ad', '4pane', 'opera', 'steam'], pkg_list
  end
end
