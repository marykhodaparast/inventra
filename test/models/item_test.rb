require "test_helper"

class ItemTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123"
    )

    @inventory = @user.inventories.create!(
      name: "My Inventory"
    )
  end

  test "should create item with a valid inventory" do
    item = @inventory.items.new(name: "Laptop")

    assert item.valid?
    assert_equal @inventory, item.inventory
  end

  test "should allow item without a category" do
    item = @inventory.items.new(name: "Laptop")

    assert item.valid?
    assert_nil item.category
  end

  test "should not allow item without a name" do
    item = @inventory.items.new

    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "should not allow category from another inventory" do
  another_inventory = @user.inventories.create!(
    name: "Another Inventory"
  )

  category = another_inventory.categories.create!(
    name: "Electronics"
  )

  item = @inventory.items.new(
    name: "Laptop",
    category: category
  )

  assert_not item.valid?
  assert_includes item.errors[:category],
                  "must belong to the same inventory"
   end
end
