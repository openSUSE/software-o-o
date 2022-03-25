# frozen_string_literal: true

require 'test_helper'

class SearchHelperTest < ActionView::TestCase
  package = Struct.new(:name, :project)
  test 'trust level should be accurate' do
    assert_equal 3, trust_level(package.new('foo', 'openSUSE:Factory'), 'openSUSE:Factory')
    assert_equal 3, trust_level(package.new('foo', 'openSUSE:Factory:Update'), 'openSUSE:Factory')
    assert_equal 3, trust_level(package.new('foo', 'openSUSE:Factory:NonFree'), 'openSUSE:Factory')
    assert_equal 1, trust_level(package.new('foo', 'some:project'), 'openSUSE:Factory')
    assert_equal 0, trust_level(package.new('foo', 'home:bob'), 'openSUSE:Factory')
  end
end
