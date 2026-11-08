require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123"
    )

    post login_path, params: {
      email: @user.email,
      password: "password123"
    }
  end

  test "should get show" do
    get profile_path
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_path
    assert_response :success
  end

  test "user cannot change their own role through profile update" do
  assert_no_changes -> { @user.reload.role } do
    patch profile_path, params: {
      user: {
        bio: "Updated bio",
        role: "admin"
      }
    }
  end
end
test "user can update their profile" do
  patch profile_path, params: {
    user: {
      name: "Updated Name",
      email: "updated@example.com",
      bio: "I am learning Ruby on Rails."
    }
  }

  @user.reload

  assert_equal "Updated Name", @user.name
  assert_equal "updated@example.com", @user.email
  assert_equal "I am learning Ruby on Rails.", @user.bio
  assert_redirected_to profile_path
end
test "user cannot update profile with invalid data" do
  patch profile_path, params: {
    user: {
      name: "",
      bio: "Updated bio"
    }
  }

  assert_response :unprocessable_entity
  assert_equal "Test User", @user.reload.name
end
end
