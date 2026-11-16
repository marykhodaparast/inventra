require "test_helper"

class DiscussionPostTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "Discussion Tester",
      email: "discussion@example.com",
      password: "password123",
      role: "user"
    )

    @inventory = Inventory.create!(
      name: "Discussion Inventory",
      visibility: "private",
      user: @user
    )
  end

  test "should create a discussion post with valid content" do
    post = DiscussionPost.new(
      content: "Hello everyone!",
      user: @user,
      inventory: @inventory
    )

    assert post.save
  end

  test "should not create a discussion post without content" do
    post = DiscussionPost.new(
      content: "",
      user: @user,
      inventory: @inventory
    )

    assert_not post.save
    assert_includes post.errors[:content], "can't be blank"
  end

  test "should belong to a user and an inventory" do
    post = DiscussionPost.create!(
      content: "Test message",
      user: @user,
      inventory: @inventory
    )

    assert_equal @user, post.user
    assert_equal @inventory, post.inventory
  end
end
