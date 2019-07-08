# frozen_string_literal: true

require 'test_helper'

class DistributionHelperTest < ActionView::TestCase
  test 'short should display correct messages' do
    assert_equal 'test', short_description('test', 0)
    assert_equal _("For CD and USB stick"), short_description(nil, 0)
    assert_equal _("For CD and USB stick"), short_description(nil, 700_000_000)
    assert_equal _("For DVD and USB stick"), short_description(nil, 700_000_001)
    assert_equal _("For DVD and USB stick"), short_description(nil, 5_000_000_000)
    assert_equal _("For USB stick"), short_description(nil, 5_000_000_001)
  end
end
