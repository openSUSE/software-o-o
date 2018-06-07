require 'test_helper'
require 'ostruct'

class SearchHelperTest < ActionView::TestCase
  test 'trust level should be accurate' do
    assert_equal 3, trust_level(OpenStruct.new(name: 'foo', project: 'openSUSE:Factory'), 'openSUSE:Factory')
    assert_equal 3, trust_level(OpenStruct.new(name: 'foo', project: 'openSUSE:Factory:Update'), 'openSUSE:Factory')
    assert_equal 3, trust_level(OpenStruct.new(name: 'foo', project: 'openSUSE:Factory:NonFree'), 'openSUSE:Factory')
    assert_equal 1, trust_level(OpenStruct.new(name: 'foo', project: 'some:project'), 'openSUSE:Factory')
    assert_equal 0, trust_level(OpenStruct.new(name: 'foo', project: 'home:bob'), 'openSUSE:Factory')
  end
end
