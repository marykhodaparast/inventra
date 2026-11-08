require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(
      name: "Admin User",
      email: "admin@example.com",
      password: "password123",
      role: "admin"
    )

    post login_path, params: {
      email: @admin.email,
      password: "password123"
    }
  end

  test "should get index" do
    get admin_users_path
    assert_response :success
  end

  test "admin can promote a user to admin" do
  user = User.create!(
    name: "Regular User",
    email: "user@example.com",
    password: "password123"
  )

  patch admin_user_path(user), params: {
    user: { role: "admin" }
  }

  assert_equal "admin", user.reload.role
  assert_redirected_to admin_users_path
end
test "cannot demote the last admin" do
  patch admin_user_path(@admin), params: {
    user: { role: "user" }
  }

  assert_equal "admin", @admin.reload.role
  assert_redirected_to admin_users_path
end
test "regular user cannot access admin users page" do
  regular_user = User.create!(
    name: "Regular User",
    email: "regular@example.com",
    password: "password123"
  )

  delete logout_path

  post login_path, params: {
    email: regular_user.email,
    password: "password123"
  }

  get admin_users_path

  assert_redirected_to root_path
end
end
