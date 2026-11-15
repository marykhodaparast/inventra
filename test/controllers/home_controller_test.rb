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
end
