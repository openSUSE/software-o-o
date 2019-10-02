# frozen_string_literal: true

require 'test_helper'

class OBSTest < ActiveSupport::TestCase
  test 'use authentication cookie' do
    # /foo is not a real request, real requests to OBS API should not
    # be mocked - VCR should be used instead
    WebMock.stub_request(:any, 'https://api.opensuse.org/foo')
           .to_return(body: "False")

    WebMock.stub_request(:any, 'https://api.opensuse.org/foo')
           .with(headers: { 'X-opensuse_data' => 'TEST' })
           .to_return(body: "True")

    response = OBS.client.get('/foo')
    assert_equal 'True', response.body
  end

  test 'search binaries data structure' do
    VCR.use_cassette('default') do
      binaries = OBS.search_published_binary('vcpkg', baseproject: 'openSUSE:Factory')

      assert_equal 2, binaries.size
    end
  end

  test 'search project quality' do
    VCR.use_cassette('default') do
      project = 'home:dmacvicar'
      project_quality = OBS.search_project_quality(project)

      assert_equal "", project_quality
    end
  end

  test 'search fileinfo for one Binary' do
    VCR.use_cassette('default') do
      binary = OBS::Binary.new(
        'project' => 'home:dmacvicar',
        'repository' => 'openSUSE_Tumbleweed',
        'arch' => 'x86_64',
        'filename' => 'vcpkg-0.0+git.1524688133.90be0d9b-9.22.x86_64.rpm'
      )
      fileinfo = OBS.search_published_binary_fileinfo(binary)

      assert_equal "C++ library manager for Linux, macOS and Windows", fileinfo.summary
    end
  end
end
