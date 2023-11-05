require "test_helper"

class CommodityCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get commodity_categories_index_url
    assert_response :success
  end
end
