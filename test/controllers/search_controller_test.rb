require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_url
    assert_response :success
  end

  test "guest can search inventories and items" do
    user = User.create!(
      name: "Search User",
      email: "search@example.com",
      password: "password123"
    )

    inventory = user.inventories.create!(
      name: "Electronics",
      description: "Electronic devices"
    )

    item = inventory.items.create!(
      name: "MacBook",
      description: "Apple laptop"
    )

    get search_url, params: { q: "Apple" }

    assert_response :success
    assert_select "h1", "Search Results"
    assert_select "td", text: "Electronics"
    assert_select "td", text: "MacBook"
  end

  test "shows a message when search query is blank" do
    get search_url, params: { q: "" }

    assert_response :success
    assert_select "p", text: "Please enter a search term or select a tag."
  end
  test "guest can search inventories by tag" do
  user = User.create!(
    name: "Tag Search User",
    email: "tag-search@example.com",
    password: "password123"
  )

  tagged_inventory = user.inventories.create!(
    name: "Technology Inventory"
  )

  other_inventory = user.inventories.create!(
    name: "Food Inventory"
  )

  tag = Tag.create!(name: "technology")
  tagged_inventory.tags << tag

  get search_url, params: { tag: "technology" }

  assert_response :success
  assert_select "td", text: "Technology Inventory"
  assert_select "td", { text: "Food Inventory", count: 0 }
end
end
