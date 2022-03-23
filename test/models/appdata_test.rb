# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class AppdataTest < ActiveSupport::TestCase
  test 'appdata can be parsed' do
    appdata = Appdata.new('leap/15.2').data
    pkg_list = appdata[:apps].map { |p| p[:pkgname] }.uniq

    assert_equal 812, pkg_list.size
    %w[abiword kaffeine yast2-instserver].each do |pkg|
      assert_includes pkg_list, pkg
    end
  end

  test 'missing appdata should not raise anything' do
    stub_request(:get, %r{https://download.opensuse.org/tumbleweed/repo/(non-)?oss/repodata/(.*)-appdata.xml.gz})
      .to_return(status: 404, body: '', headers: {})

    appdata = Appdata.new('tumbleweed').data
    assert_empty appdata[:apps]
  end
end
