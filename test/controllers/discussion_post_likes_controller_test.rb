require "test_helper"

class DiscussionPostLikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create!(
      name: "Inventory Owner",
      email: "owner@example.com",
      password: "Secret123!"
    )

    @writer = User.create!(
      name: "Discussion Writer",
      email: "writer@example.com",
      password: "Secret123!"
    )

    @inventory = Inventory.create!(
      name: "Private Inventory",
      visibility: "private",
      user: @owner
    )

    @discussion_post = DiscussionPost.create!(
      inventory: @inventory,
      user: @owner,
      content: "A discussion message"
    )
  end

  test "guest cannot like a discussion post" do
    assert_no_difference "DiscussionPostLike.count" do
      post inventory_discussion_post_like_url(
        @inventory,
        @discussion_post
      )
    end

    assert_redirected_to login_path
  end

  test "logged in user can like a discussion post" do
    post login_url, params: {
      email: @writer.email,
      password: "Secret123!"
    }

    assert_difference "DiscussionPostLike.count", 1 do
      post inventory_discussion_post_like_url(
        @inventory,
        @discussion_post
      )
    end

    like = DiscussionPostLike.last

    assert_equal @writer, like.user
    assert_equal @discussion_post, like.discussion_post
    assert_redirected_to inventory_items_path(@inventory)
  end

  test "user cannot create duplicate likes" do
    post login_url, params: {
      email: @writer.email,
      password: "Secret123!"
    }

    post inventory_discussion_post_like_url(
      @inventory,
      @discussion_post
    )

    assert_no_difference "DiscussionPostLike.count" do
      post inventory_discussion_post_like_url(
        @inventory,
        @discussion_post
      )
    end
  end

  test "logged in user can remove their like" do
    post login_url, params: {
      email: @writer.email,
      password: "Secret123!"
    }

    DiscussionPostLike.create!(
      user: @writer,
      discussion_post: @discussion_post
    )

    assert_difference "DiscussionPostLike.count", -1 do
      delete inventory_discussion_post_like_url(
        @inventory,
        @discussion_post
      )
    end

    assert_redirected_to inventory_items_path(@inventory)
  end

  test "guest cannot remove a like" do
    DiscussionPostLike.create!(
      user: @writer,
      discussion_post: @discussion_post
    )

    assert_no_difference "DiscussionPostLike.count" do
      delete inventory_discussion_post_like_url(
        @inventory,
        @discussion_post
      )
    end

    assert_redirected_to login_path
  end
end