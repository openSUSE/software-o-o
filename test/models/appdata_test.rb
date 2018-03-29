require File.expand_path('../../test_helper', __FILE__)

class AppdataTest < ActiveSupport::TestCase
  test 'Factory Appdata can be parsed' do
    appdata = Appdata.get('factory')
    pkg_list = appdata[:apps].map { |p| p[:pkgname] }.uniq

    assert_equal 4, pkg_list.size
    assert_equal ['0ad', '4pane', 'opera', 'steam'], pkg_list
  end

  test 'Missing appdata should not raise anything' do
    stub_content("download.opensuse.org/tumbleweed/repo/oss/repodata/#{APPDATA_CHECKSUM}-appdata.xml.gz", status: [404, "Not found"])
    appdata = Appdata.get('factory')
    # Should at least include the standard searches
    assert_not_empty appdata[:apps]
    assert_includes appdata[:apps].map { |e| e[:name] }, 'Opera'
  end
end
