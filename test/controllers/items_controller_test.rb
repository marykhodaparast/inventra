
require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Mary",
      email: "mary@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    @inventory = @user.inventories.create!(
      name: "My Inventory"
    )

    @category = @inventory.categories.create!(
      name: "Electronics"
    )

    @item = @inventory.items.create!(
      name: "Laptop",
      description: "My personal laptop",
      category: @category
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }
  end

  test "should display inventory items" do
    get inventory_items_url(@inventory)

    assert_response :success
    assert_select "h2", "Laptop"
  end

  test "should display new item form" do
    get new_inventory_item_url(@inventory)

    assert_response :success
    assert_select "form"
  end

  test "should create item" do
    assert_difference("Item.count", 1) do
      post inventory_items_url(@inventory), params: {
        item: {
          name: "Keyboard",
          description: "Mechanical keyboard",
          category_id: @category.id
        }
      }
    end

    created_item = Item.order(:id).last

    assert_redirected_to inventory_item_path(@inventory, created_item)
  end

  test "should display item details" do
    get inventory_item_url(@inventory, @item)

    assert_response :success
    assert_select "h1", "Laptop"
  end

  test "should not allow guest to access items" do
    delete logout_url

    get inventory_items_url(@inventory)

    assert_redirected_to login_path
  end

  test "should not allow user to access another user's inventory items" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    get inventory_items_url(other_inventory)

    assert_response :not_found
  end

  test "should not allow user to view item from another inventory" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    other_item = other_inventory.items.create!(
      name: "Private Item"
    )

    get inventory_item_url(@inventory, other_item)

    assert_response :not_found
  end

  test "should display edit item form" do
    get edit_inventory_item_url(@inventory, @item)

    assert_response :success
    assert_select "h1", "Edit Item - My Inventory"
  end

  test "should update item" do
    patch inventory_item_url(@inventory, @item), params: {
      item: {
        name: "Updated Laptop",
        description: "Updated description",
        category_id: @category.id
      }
    }

    assert_redirected_to inventory_item_path(@inventory, @item)

    @item.reload

    assert_equal "Updated Laptop", @item.name
    assert_equal "Updated description", @item.description
  end

  test "should not update item with invalid data" do
    patch inventory_item_url(@inventory, @item), params: {
      item: {
        name: "",
        description: "Updated description"
      }
    }

    assert_response :unprocessable_entity

    @item.reload

    assert_equal "Laptop", @item.name
  end

  test "should delete item" do
    assert_difference("Item.count", -1) do
      delete inventory_item_url(@inventory, @item)
    end

    assert_redirected_to inventory_items_path(@inventory)
  end

  test "should not allow user to edit item from another inventory" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    other_item = other_inventory.items.create!(
      name: "Private Item"
    )

    get edit_inventory_item_url(@inventory, other_item)

    assert_response :not_found
  end

  test "should not allow user to update item from another inventory" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    other_item = other_inventory.items.create!(
      name: "Private Item"
    )

    patch inventory_item_url(@inventory, other_item), params: {
      item: { name: "Hacked Item" }
    }

    assert_response :not_found
    assert_equal "Private Item", other_item.reload.name
  end

  test "should not allow user to delete item from another inventory" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    other_item = other_inventory.items.create!(
      name: "Private Item"
    )

    assert_no_difference("Item.count") do
      delete inventory_item_url(@inventory, other_item)
    end

    assert_response :not_found
  end
  test "should not create item with category from another inventory" do
    other_inventory = @user.inventories.create!(
      name: "Second Inventory"
    )

    other_category = other_inventory.categories.create!(
      name: "Other Category"
    )

    assert_no_difference("Item.count") do
      post inventory_items_url(@inventory), params: {
        item: {
          name: "Invalid Item",
          category_id: other_category.id
        }
      }
    end

    assert_response :unprocessable_entity
  end
    test "should create item with custom field values" do
    field = @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    assert_difference("Item.count", 1) do
      post inventory_items_url(@inventory), params: {
        item: {
          name: "New Book",
          custom_field_values: {
            field.id.to_s => "John"
          }
        }
      }
    end

    created_item = Item.order(:id).last

    assert_equal "John", created_item.custom_field_values[field.id.to_s]
    assert_redirected_to inventory_item_path(@inventory, created_item)
  end

  test "should update item custom field values" do
    field = @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    patch inventory_item_url(@inventory, @item), params: {
      item: {
        custom_field_values: {
          field.id.to_s => "Jane"
        }
      }
    }

    assert_redirected_to inventory_item_path(@inventory, @item)

    @item.reload

    assert_equal "Jane", @item.custom_field_values[field.id.to_s]
  end

    test "should preserve existing custom field values when updating other attributes" do
    field = @inventory.custom_fields.create!(
      name: "Author",
      field_type: "text"
    )

    @item.update!(
      custom_field_values: { field.id.to_s => "John" }
    )

    patch inventory_item_url(@inventory, @item), params: {
      item: { name: "Updated Laptop" }
    }

    @item.reload

    assert_equal "John", @item.custom_field_values[field.id.to_s]
  end

  test "should update boolean custom field value to false" do
    field = @inventory.custom_fields.create!(
      name: "Available",
      field_type: "boolean"
    )

    @item.update!(
      custom_field_values: { field.id.to_s => true }
    )

    patch inventory_item_url(@inventory, @item), params: {
      item: {
        custom_field_values: {
          field.id.to_s => "0"
        }
      }
    }

    @item.reload

    assert_equal false, @item.custom_field_values[field.id.to_s]
  end
end
