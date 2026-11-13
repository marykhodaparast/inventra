require "test_helper"

class InventoryTest < ActiveSupport::TestCase
  test "inventory belongs to a user" do
    user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123"
    )

    inventory = user.inventories.create!(
      name: "My First Inventory"
    )

    assert_equal user, inventory.user
    assert_includes user.inventories, inventory
  end

  test "generates a custom id automatically" do
    user = User.create!(
      name: "Custom ID User",
      email: "custom-id@example.com",
      password: "password123"
    )

    inventory = user.inventories.create!(
      name: "Custom ID Inventory"
    )

    assert_match(/\AINV-\d{6,}\z/, inventory.custom_id)
  end

  test "generates unique custom ids for different inventories" do
    user = User.create!(
      name: "Unique ID User",
      email: "unique-id@example.com",
      password: "password123"
    )

    first_inventory = user.inventories.create!(name: "First Inventory")
    second_inventory = user.inventories.create!(name: "Second Inventory")

    assert_not_equal first_inventory.custom_id, second_inventory.custom_id
  end
end
