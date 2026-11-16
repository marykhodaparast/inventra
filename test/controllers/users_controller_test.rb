require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url

    assert_response :success
  end

  test "should create user with valid data" do
    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          name: "Mary",
          email: "mary@example.com",
          password: "Secret123!",
          password_confirmation: "Secret123!"
        }
      }
    end

    assert_redirected_to root_path
  end

  test "should not create user with invalid data" do
    assert_no_difference("User.count") do
      post users_url, params: {
        user: {
          name: "",
          email: "invalid-email",
          password: "Secret123!",
          password_confirmation: "Secret123!"
        }
      }
    end

    assert_response :unprocessable_entity
  end
  test "guest can view a public user profile" do
  user = User.create!(
    name: "Profile Tester",
    email: "profile@example.com",
    password: "Secret123!",
    role: "user",
    bio: "Ruby on Rails developer"
  )

  get user_url(user)

  assert_response :success
  assert_select "h1", "User Profile"
  assert_select "p", /Profile Tester/
  assert_select "p", /Ruby on Rails developer/
  assert_no_match user.email, response.body
end

test "public profile does not expose user email" do
  user = User.create!(
    name: "Private Email User",
    email: "private@example.com",
    password: "Secret123!",
    role: "user"
  )

  get user_url(user)

  assert_response :success
  assert_no_match user.email, response.body
end
end
