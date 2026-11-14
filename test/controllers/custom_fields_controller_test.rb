require "test_helper"

class CustomFieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Mary",
      email: "custom-fields@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    @inventory = @user.inventories.create!(
      name: "My Inventory"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }
  end

  test "should create custom field" do
    assert_difference("CustomField.count", 1) do
      post inventory_custom_fields_url(@inventory), params: {
        custom_field: {
          name: "Author",
          field_type: "text"
        }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)

    custom_field = @inventory.custom_fields.last
    assert_equal "Author", custom_field.name
    assert_equal "text", custom_field.field_type
    assert_equal 1, custom_field.position
  end

  test "should update custom field" do
    custom_field = @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    patch inventory_custom_field_url(@inventory, custom_field), params: {
      custom_field: {
        name: "Publisher",
        field_type: "textarea"
      }
    }

    assert_redirected_to edit_inventory_path(@inventory)
    assert_equal "Publisher", custom_field.reload.name
    assert_equal "textarea", custom_field.field_type
  end

  test "should destroy custom field" do
    custom_field = @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    assert_difference("CustomField.count", -1) do
      delete inventory_custom_field_url(@inventory, custom_field)
    end

    assert_redirected_to edit_inventory_path(@inventory)
    assert_not CustomField.exists?(custom_field.id)
  end

  test "should not create custom field with blank name" do
    assert_no_difference("CustomField.count") do
      post inventory_custom_fields_url(@inventory), params: {
        custom_field: {
          name: "",
          field_type: "text"
        }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
  end

  test "should not create custom field with invalid field type" do
    assert_no_difference("CustomField.count") do
      post inventory_custom_fields_url(@inventory), params: {
        custom_field: {
          name: "Author",
          field_type: "invalid"
        }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
  end

  test "should not create duplicate custom field name in the same inventory" do
    @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    assert_no_difference("CustomField.count") do
      post inventory_custom_fields_url(@inventory), params: {
        custom_field: {
          name: "Author",
          field_type: "text"
        }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
  end
  test "should not allow access to another user's inventory" do
  other_user = User.create!(
    name: "Other User",
    email: "other-custom-fields@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!"
  )

  other_inventory = other_user.inventories.create!(
    name: "Other Inventory"
  )

  assert_no_difference("CustomField.count") do
    post inventory_custom_fields_url(other_inventory), params: {
      custom_field: {
        name: "Private Field",
        field_type: "text"
      }
    }
  end

  assert_redirected_to inventories_path
end

test "should not allow updating another user's custom field" do
  other_user = User.create!(
    name: "Other User",
    email: "other-update@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!"
  )

  other_inventory = other_user.inventories.create!(
    name: "Other Inventory"
  )

  custom_field = other_inventory.custom_fields.create!(
    name: "Private Field",
    field_type: "text"
  )

  assert_no_changes -> { custom_field.reload.name } do
    patch inventory_custom_field_url(other_inventory, custom_field), params: {
      custom_field: { name: "Hacked Field" }
    }
  end

  assert_redirected_to inventories_path
end

test "should not allow deleting another user's custom field" do
  other_user = User.create!(
    name: "Other User",
    email: "other-delete@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!"
  )

  other_inventory = other_user.inventories.create!(
    name: "Other Inventory"
  )

  custom_field = other_inventory.custom_fields.create!(
    name: "Private Field",
    field_type: "text"
  )

  assert_no_difference("CustomField.count") do
    delete inventory_custom_field_url(other_inventory, custom_field)
  end

  assert_redirected_to inventories_path
  assert CustomField.exists?(custom_field.id)
end
end
