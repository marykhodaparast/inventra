
require "test_helper"

class DiscussionPostLikeTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "Like Tester",
      email: "like@example.com",
      password: "password123",
      role: "user"
    )

    @second_user = User.create!(
      name: "Second Like Tester",
      email: "second-like@example.com",
      password: "password123",
      role: "user"
    )

    @inventory = Inventory.create!(
      name: "Like Test Inventory",
      visibility: "private",
      user: @user
    )

    @discussion_post = DiscussionPost.create!(
      content: "Test discussion post",
      user: @user,
      inventory: @inventory
    )
  end

  test "should create a like for a discussion post" do
    like = @discussion_post.discussion_post_likes.create!(user: @user)

    assert like.persisted?
    assert_equal 1, @discussion_post.discussion_post_likes.count
  end

  test "should not allow the same user to like a post twice" do
    @discussion_post.discussion_post_likes.create!(user: @user)

    duplicate_like = @discussion_post.discussion_post_likes.new(user: @user)

    assert_not duplicate_like.save
    assert_includes duplicate_like.errors[:user_id], "has already been taken"
    assert_equal 1, @discussion_post.discussion_post_likes.count
  end

  test "should allow different users to like the same post" do
    @discussion_post.discussion_post_likes.create!(user: @user)
    second_like = @discussion_post.discussion_post_likes.create!(user: @second_user)

    assert second_like.persisted?
    assert_equal 2, @discussion_post.discussion_post_likes.count
  end

  test "should delete associated likes when discussion post is destroyed" do
    @discussion_post.discussion_post_likes.create!(user: @user)

    assert_difference("DiscussionPostLike.count", -1) do
      @discussion_post.destroy
    end
  end

  test "should delete associated likes when user is destroyed" do
    @discussion_post.discussion_post_likes.create!(user: @second_user)

    assert_difference("DiscussionPostLike.count", -1) do
      @second_user.destroy
    end
  end
end
