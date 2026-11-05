require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Mary",
      email: "mary@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )
  end

  test "should get login page" do
    get login_url

    assert_response :success
  end

  test "should login with valid credentials" do
    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    assert_redirected_to root_path
    assert_equal @user.id, session[:user_id]
  end

  test "should not login with invalid credentials" do
    post login_url, params: {
      email: @user.email,
      password: "WrongPassword"
    }

    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should logout successfully" do
    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    delete logout_url

    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
