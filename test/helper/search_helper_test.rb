# frozen_string_literal: true

require 'test_helper'

class SearchHelperTest < ActionView::TestCase
  test 'trust level should be accurate' do
    Package = Struct.new(:name, :project)
    assert_equal 3, trust_level(Package.new('foo', 'openSUSE:Factory'), 'openSUSE:Factory')
    assert_equal 3, trust_level(Package.new('foo', 'openSUSE:Factory:Update'), 'openSUSE:Factory')
    assert_equal 3, trust_level(Package.new('foo', 'openSUSE:Factory:NonFree'), 'openSUSE:Factory')
    assert_equal 1, trust_level(Package.new('foo', 'some:project'), 'openSUSE:Factory')
    assert_equal 0, trust_level(Package.new('foo', 'home:bob'), 'openSUSE:Factory')
  end
end
