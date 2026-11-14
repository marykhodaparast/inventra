require "test_helper"

class InventoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Mary",
      email: "mary@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )
  end

  test "should allow guest to view inventories" do
  @user.inventories.create!(
    name: "Publicly Visible Inventory"
  )

  get inventories_url

  assert_response :success
  assert_select "body", text: /Publicly Visible Inventory/
end

  test "should allow logged in user to access inventories" do
    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    get inventories_url

    assert_response :success
  end

  test "should create inventory" do
    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    assert_difference("Inventory.count", 1) do
      post inventories_url, params: {
        inventory: {
          name: "Work Inventory",
          description: "Inventory for work",
          visibility: "private"
        }
      }
    end

    assert_redirected_to inventories_path

    created_inventory = @user.inventories.order(:id).last

    assert_equal "Work Inventory", created_inventory.name
    assert_equal "private", created_inventory.visibility
  end

  test "should update inventory" do
    inventory = @user.inventories.create!(
      name: "Old Inventory",
      description: "Old description",
      visibility: "private"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    patch inventory_url(inventory), params: {
      inventory: {
        name: "Updated Inventory",
        description: "Updated description",
        visibility: "public"
      }
    }

    assert_redirected_to inventories_path

    inventory.reload

    assert_equal "Updated Inventory", inventory.name
    assert_equal "Updated description", inventory.description
    assert_equal "public", inventory.visibility
  end

  test "should not update inventory with invalid data" do
    inventory = @user.inventories.create!(
      name: "My Inventory",
      description: "Original description",
      visibility: "private"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    patch inventory_url(inventory), params: {
      inventory: {
        name: "",
        description: "Changed description"
      }
    }

    assert_response :unprocessable_entity

    inventory.reload

    assert_equal "My Inventory", inventory.name
    assert_equal "Original description", inventory.description
  end

  test "should delete inventory" do
    inventory = @user.inventories.create!(
      name: "Inventory to Delete"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    assert_difference("Inventory.count", -1) do
      delete inventory_url(inventory)
    end

    assert_redirected_to inventories_path
    assert_not Inventory.exists?(inventory.id)
  end

  test "should not allow user to edit another user's inventory" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    inventory = other_user.inventories.create!(
      name: "Other User Inventory"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    get edit_inventory_url(inventory)

    assert_redirected_to inventories_path
  end

  test "should not allow user to update another user's inventory" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    inventory = other_user.inventories.create!(
      name: "Other User Inventory"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    patch inventory_url(inventory), params: {
      inventory: { name: "Hacked Inventory" }
    }

    assert_redirected_to inventories_path
    assert_equal "Other User Inventory", inventory.reload.name
  end

  test "should not allow user to delete another user's inventory" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    inventory = other_user.inventories.create!(
      name: "Other User Inventory"
    )

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    assert_no_difference("Inventory.count") do
      delete inventory_url(inventory)
    end

    assert_redirected_to inventories_path
  end
    test "should not create inventory with blank name" do
    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    assert_no_difference("Inventory.count") do
      post inventories_url, params: {
        inventory: {
          name: "",
          description: "Invalid inventory",
          visibility: "private"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should not create inventory with invalid visibility" do
    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }

    assert_no_difference("Inventory.count") do
      post inventories_url, params: {
        inventory: {
          name: "Invalid Inventory",
          description: "Invalid visibility",
          visibility: "invalid"
        }
      }
    end

    assert_response :unprocessable_entity
  end
  test "should redirect guest when trying to create inventory" do
  assert_no_difference("Inventory.count") do
    post inventories_url, params: {
      inventory: {
        name: "Guest Inventory",
        description: "Created by guest",
        visibility: "private"
      }
    }
  end

  assert_redirected_to login_path
end
test "should allow admin to update another user's inventory" do
  admin = User.create!(
    name: "Admin User",
    email: "admin@example.com",
    password: "Secret123!",
    password_confirmation: "Secret123!",
    role: "admin"
  )

  inventory = @user.inventories.create!(
    name: "Original Inventory"
  )

  post login_url, params: {
    email: admin.email,
    password: "Secret123!"
  }

  patch inventory_url(inventory), params: {
    inventory: { name: "Updated by Admin" }
  }

  assert_redirected_to inventories_path
  assert_equal "Updated by Admin", inventory.reload.name
end
test "should redirect guest when trying to edit inventory" do
  inventory = @user.inventories.create!(
    name: "Protected Inventory"
  )

  get edit_inventory_url(inventory)

  assert_redirected_to login_path
end
test "should redirect guest when trying to update inventory" do
  inventory = @user.inventories.create!(
    name: "Protected Inventory"
  )

  patch inventory_url(inventory), params: {
    inventory: { name: "Changed by Guest" }
  }

  assert_redirected_to login_path
  assert_equal "Protected Inventory", inventory.reload.name
end
test "should redirect guest when trying to delete inventory" do
  inventory = @user.inventories.create!(
    name: "Protected Inventory"
  )

  assert_no_difference("Inventory.count") do
    delete inventory_url(inventory)
  end

  assert_redirected_to login_path
  assert_equal "Protected Inventory", inventory.reload.name
end
end
