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
end
