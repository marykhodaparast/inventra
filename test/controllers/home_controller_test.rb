require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end
  test "homepage displays tag cloud with inventory counts" do
  user = User.create!(
    name: "Home User",
    email: "home@example.com",
    password: "password123"
  )

  first_inventory = user.inventories.create!(
    name: "Technology Inventory"
  )

  second_inventory = user.inventories.create!(
    name: "Programming Inventory"
  )

  tag = Tag.create!(name: "technology")

  first_inventory.tags << tag
  second_inventory.tags << tag

  get root_url

  assert_response :success
  assert_select "h2", "Tag Cloud"
  assert_select "a", text: /technology \(2\)/
end

test "homepage displays popular inventories ordered by item count" do
  user = User.create!(
    name: "Statistics User",
    email: "statistics@example.com",
    password: "password123"
  )

  popular_inventory = user.inventories.create!(
    name: "Popular Inventory"
  )

  medium_inventory = user.inventories.create!(
    name: "Medium Inventory"
  )

  empty_inventory = user.inventories.create!(
    name: "Empty Inventory"
  )

  3.times do |index|
    popular_inventory.items.create!(name: "Popular Item #{index}")
  end

  2.times do |index|
    medium_inventory.items.create!(name: "Medium Item #{index}")
  end

  get root_url

  assert_response :success

  assert_select "h2", "Popular Inventories"

  assert_select "table" do
    assert_select "tr", minimum: 4
    assert_select "td", text: "Popular Inventory"
    assert_select "td", text: "Medium Inventory"
    assert_select "td", text: "Empty Inventory"
    assert_select "td", text: "3"
    assert_select "td", text: "2"
    assert_select "td", text: "0"
  end

  popular_section = response.body.split("<h2>Popular Inventories</h2>").last
popular_section = popular_section.split("<h2>").first

assert_operator popular_section.index("Popular Inventory"),
                :<,
                popular_section.index("Medium Inventory")

assert_operator popular_section.index("Medium Inventory"),
                :<,
                popular_section.index("Empty Inventory")
end

test "homepage does not display tags without inventories" do
  Tag.create!(name: "unused-tag")

  get root_url

  assert_response :success
  assert_select "h2", "Tag Cloud"
  assert_select "a", text: /unused-tag/, count: 0
end
end
