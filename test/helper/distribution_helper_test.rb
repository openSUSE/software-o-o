# frozen_string_literal: true

require 'test_helper'

class DistributionHelperTest < ActionView::TestCase
  test 'short description given medium without predefined description' do
    # VCR has trouble with :head request
    WebMock.stub_request(:head, 'https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Current.iso')
           .to_return(headers: { 'content_length' => 4_689_231_872 })
    WebMock.stub_request(:head, 'https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-NET-x86_64-Current.iso')
           .to_return(headers: { 'content_length' => 135_266_304 })

    dvd_image = { "name" => "DVD Image",
                  "primary_link" => "/tumbleweed/iso/openSUSE-Tumbleweed-DVD-x86_64-Current.iso" }
    network_image = { "name" => "Network Image",
                      "primary_link" => "/tumbleweed/iso/openSUSE-Tumbleweed-NET-x86_64-Current.iso" }

    assert_equal 'For DVD and USB stick', short_description(dvd_image)
    assert_equal 'For CD and USB stick', short_description(network_image)
  end

  test 'short description given medium with predefined description' do
    medium = { "name" => "KVM and XEN", "short" => "For use in KVM or XEN HVM hypervisors" }

    assert_equal medium['short'], short_description(medium)
  end
end
