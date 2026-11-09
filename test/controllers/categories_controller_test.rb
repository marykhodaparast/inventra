require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Mary",
      email: "mary@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    @inventory = @user.inventories.create!(
      name: "My Inventory"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }
  end

  test "should create category" do
    assert_difference("Category.count", 1) do
      post inventory_categories_url(@inventory), params: {
        category: { name: "Books" }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
    assert_equal "Books", @inventory.categories.last.name
  end
  test "should update category" do
  category = @inventory.categories.create!(name: "Books")

  patch inventory_category_url(@inventory, category), params: {
    category: { name: "Programming Books" }
  }

  assert_redirected_to edit_inventory_path(@inventory)
  assert_equal "Programming Books", category.reload.name
end
test "should destroy category" do
  category = @inventory.categories.create!(name: "Books")

  assert_difference("Category.count", -1) do
    delete inventory_category_url(@inventory, category)
  end

  assert_redirected_to edit_inventory_path(@inventory)
  assert_not Category.exists?(category.id)
end
test "should not allow user to access another user's inventory categories" do
  other_user = User.create!(
    name: "Other User",
    email: "other@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!"
  )

  other_inventory = other_user.inventories.create!(
    name: "Other Inventory"
  )

  assert_no_difference("Category.count") do
    post inventory_categories_url(other_inventory), params: {
      category: { name: "Unauthorized Category" }
    }
  end

  assert_response :not_found
end
test "should not create category with duplicate name in the same inventory" do
  @inventory.categories.create!(name: "Books")

  assert_no_difference("Category.count") do
    post inventory_categories_url(@inventory), params: {
      category: { name: "Books" }
    }
  end

  assert_redirected_to edit_inventory_path(@inventory)
end
end
