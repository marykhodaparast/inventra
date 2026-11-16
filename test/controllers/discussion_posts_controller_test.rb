require "test_helper"

class DiscussionPostsControllerTest < ActionDispatch::IntegrationTest
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
  end

  test "guest cannot create a discussion post" do
    assert_no_difference "DiscussionPost.count" do
      post inventory_discussion_posts_url(@inventory), params: {
        discussion_post: { content: "Hello!" }
      }
    end

    assert_redirected_to login_path
  end

  test "logged in user can create a discussion post without write access" do
    post login_url, params: {
      email: @writer.email,
      password: "Secret123!"
    }

    assert_difference "DiscussionPost.count", 1 do
      post inventory_discussion_posts_url(@inventory), params: {
        discussion_post: { content: "Hello everyone!" }
      }
    end

    discussion_post = DiscussionPost.last

    assert_equal @writer, discussion_post.user
    assert_equal @inventory, discussion_post.inventory
    assert_equal "Hello everyone!", discussion_post.content
    assert_redirected_to inventory_items_path(@inventory)
  end
  test "index returns discussion posts inside a turbo frame" do
  discussion_post = DiscussionPost.create!(
    inventory: @inventory,
    user: @writer,
    content: "Hello **Inventra**!"
  )

  get inventory_discussion_posts_url(@inventory)

  assert_response :success
  assert_select "turbo-frame#discussion_posts"
  assert_select "strong", "Inventra"
  assert_includes response.body, @writer.name
end
end
