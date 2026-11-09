require "test_helper"

class InventoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Mary",
      email: "mary@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )
  end

  test "should redirect guest to login page" do
    get inventories_url

    assert_redirected_to login_path
  end

  test "should allow logged in user to access inventories" do
    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    get inventories_url

    assert_response :success
  end

  test "should not allow user to edit another user's inventory" do
  other_user = User.create!(
    name: "Other User",
    email: "other@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!"
  )

  inventory = other_user.inventories.create!(
    name: "Other User Inventory"
  )

  post login_url, params: {
    email: @user.email,
    password: "Secret123!"
  }

  get edit_inventory_url(inventory)

  assert_response :not_found
end
test "should not allow user to update another user's inventory" do
  other_user = User.create!(
    name: "Other User",
    email: "other@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!"
  )

  inventory = other_user.inventories.create!(
    name: "Other User Inventory"
  )

  post login_url, params: {
    email: @user.email,
    password: "Secret123!"
  }

  patch inventory_url(inventory), params: {
    inventory: { name: "Hacked Inventory" }
  }

  assert_response :not_found
  assert_equal "Other User Inventory", inventory.reload.name
end

test "should not allow user to delete another user's inventory" do
  other_user = User.create!(
    name: "Other User",
    email: "other@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!"
  )

  inventory = other_user.inventories.create!(
    name: "Other User Inventory"
  )

  post login_url, params: {
    email: @user.email,
    password: "Secret123!"
  }

  assert_no_difference("Inventory.count") do
    delete inventory_url(inventory)
  end

  assert_response :not_found
end
end
