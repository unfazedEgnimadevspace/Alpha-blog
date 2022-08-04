require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest
  test "get new category path and create new category" do
    get new_category_path
    assert_response :success

    assert_difference "Category.count", 1 do
      post categories_path, params: { category: { name: "Sports"} }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Sports", response.body
  end

  test "get new category path and reject invalid categories" do
    get new_category_path
    assert_response :success

    assert_no_difference 'Category.count' do
      post categories_path , params: { category: { name: "R"} }
    end
    assert_template 'new'
    assert_select "div.alert"
    assert_select "h3.alert-heading"
    assert_match "errors", response.body
  end
end
