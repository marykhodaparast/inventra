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
     test "should save custom text field value" do
    field = @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    item = @inventory.items.create!(
      name: "Book",
      custom_field_values: { field.id.to_s => "John" }
    )

    assert_equal "John", item.custom_field_values[field.id.to_s]
  end

  test "should convert number field value to a number" do
    field = @inventory.custom_fields.create!(
      name: "Price",
      field_type: "number"
    )

    item = @inventory.items.create!(
      name: "Laptop",
      custom_field_values: { field.id.to_s => "1200" }
    )

    assert_equal 1200.0, item.custom_field_values[field.id.to_s]
  end

  test "should convert boolean field value to true" do
    field = @inventory.custom_fields.create!(
      name: "Available",
      field_type: "boolean"
    )

    item = @inventory.items.create!(
      name: "Laptop",
      custom_field_values: { field.id.to_s => "1" }
    )

    assert_equal true, item.custom_field_values[field.id.to_s]
  end

  test "should reject invalid number field value" do
    field = @inventory.custom_fields.create!(
      name: "Price",
      field_type: "number"
    )

    item = @inventory.items.new(
      name: "Laptop",
      custom_field_values: { field.id.to_s => "abc" }
    )

    assert_not item.valid?
    assert_includes item.errors[:base], "Price must be a valid number"
  end

  test "should ignore custom field values from another inventory" do
    another_inventory = @user.inventories.create!(
      name: "Another Inventory"
    )

    foreign_field = another_inventory.custom_fields.create!(
      name: "Secret",
      field_type: "text"
    )

    item = @inventory.items.create!(
      name: "Laptop",
      custom_field_values: { foreign_field.id.to_s => "Hidden value" }
    )

    assert_not item.custom_field_values.key?(foreign_field.id.to_s)
  end
end
