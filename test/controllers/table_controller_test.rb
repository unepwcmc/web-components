require 'test_helper'

class TableControllerTest < ActionDispatch::IntegrationTest
  test "should post list" do
    get '/table'
    assert_response :success

  end
end
