require 'test_helper'

class CycleCatagorizerControllerTest < ActionController::TestCase
  test "should get cycle_catgories" do
    get :cycle_catgories
    assert_response :success
  end

end
