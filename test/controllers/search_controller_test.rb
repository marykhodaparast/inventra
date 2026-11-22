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
    assert_select "p", text: "Search inventories and items or explore content by tag."
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
test "guest can search items by description" do
  user = User.create!(
    name: "Description Search User",
    email: "description-search@example.com",
    password: "password123"
  )

  inventory = user.inventories.create!(
    name: "Office Inventory"
  )

  matching_item = inventory.items.create!(
    name: "Laptop",
    description: "Professional development workstation"
  )

  inventory.items.create!(
    name: "Chair",
    description: "Comfortable office furniture"
  )

  get search_url, params: { q: "development workstation" }

  assert_response :success
  assert_select "td", text: matching_item.name
  assert_select "td", { text: "Chair", count: 0 }
end

test "guest can search items by category name" do
  user = User.create!(
    name: "Category Search User",
    email: "category-search@example.com",
    password: "password123"
  )

  inventory = user.inventories.create!(
    name: "Office Inventory"
  )

  category = inventory.categories.create!(
    name: "Electronics"
  )

  item = inventory.items.create!(
    name: "Laptop",
    category: category
  )

  inventory.items.create!(
    name: "Desk"
  )

  get search_url, params: { q: "Electronics" }

  assert_response :success
  assert_select "td", text: item.name
  assert_select "td", { text: "Desk", count: 0 }
end

test "guest gets no results for an unmatched search query" do
  user = User.create!(
    name: "Unmatched Search User",
    email: "unmatched-search@example.com",
    password: "password123"
  )

  inventory = user.inventories.create!(
    name: "Office Inventory"
  )

  inventory.items.create!(
    name: "Laptop",
    description: "Development computer"
  )

  get search_url, params: { q: "nonexistentterm" }

  assert_response :success
  assert_select "td", { text: "Laptop", count: 0 }
  assert_select "td", { text: "Office Inventory", count: 0 }
end
end
