require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password is securely hashed" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "Secret123!"
    )

    assert user.password_digest.present?
    assert_not_equal "Secret123!", user.password_digest
  end

  test "authenticates with correct password" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "Secret123!"
    )

    assert_equal user, user.authenticate("Secret123!")
  end

  test "rejects incorrect password" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "Secret123!"
    )

    assert_not user.authenticate("WrongPassword123")
  end
    test "is invalid without a name" do
    user = User.new(
      email: "test@example.com",
      password: "Secret123!"
    )

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "is invalid without an email" do
    user = User.new(
      name: "Test User",
      password: "Secret123!"
    )

    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "does not allow duplicate emails" do
    User.create!(
      name: "First User",
      email: "test@example.com",
      password: "Secret123!"
    )

    duplicate_user = User.new(
      name: "Second User",
      email: "test@example.com",
      password: "Secret123!"
    )

    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end
  test "normalizes email before validation" do
  user = User.new(
    name: "Test User",
    email: "  Maryam@Example.COM  ",
    password: "Secret123!"
  )

  user.valid?

  assert_equal "maryam@example.com", user.email
end
end
