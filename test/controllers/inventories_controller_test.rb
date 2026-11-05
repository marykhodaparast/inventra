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
end
