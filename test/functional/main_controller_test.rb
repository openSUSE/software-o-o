require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :redirect
  end
end
