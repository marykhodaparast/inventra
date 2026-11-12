require "test_helper"

class CustomFieldTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Test User",
      email: "custom-field-test@example.com",
      password: "password123",
      role: "user"
    )

    @inventory = Inventory.create!(
      user: @user,
      name: "Test Inventory",
      visibility: "private"
    )
  end

  test "should not save custom field without name" do
    custom_field = @inventory.custom_fields.new(field_type: "text")

    assert_not custom_field.valid?
    assert_includes custom_field.errors[:name], "can't be blank"
  end

  test "should not save custom field with invalid field type" do
    custom_field = @inventory.custom_fields.new(
      name: "Author",
      field_type: "invalid"
    )

    assert_not custom_field.valid?
  end

  test "should not save custom field without field type" do
    custom_field = @inventory.custom_fields.new(name: "Author")

    assert_not custom_field.valid?
  end

  test "should not allow duplicate field names in the same inventory" do
    @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    duplicate_field = @inventory.custom_fields.new(
      name: "Author",
      field_type: "text"
    )

    assert_not duplicate_field.valid?
  end

  test "should allow the same field name in different inventories" do
    @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    another_inventory = Inventory.create!(
      user: @user,
      name: "Another Inventory",
      visibility: "private"
    )

    custom_field = another_inventory.custom_fields.new(
      name: "Author",
      field_type: "text"
    )

    assert custom_field.valid?
  end

  test "should not allow negative position" do
    custom_field = @inventory.custom_fields.new(
      name: "Author",
      field_type: "text",
      position: -1
    )

    assert_not custom_field.valid?
  end
end
