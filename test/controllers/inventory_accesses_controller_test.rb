require "test_helper"

class InventoryAccessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create!(
      name: "Mary",
      email: "mary@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    @target_user = User.create!(
      name: "Sara",
      email: "sara@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    @inventory = @owner.inventories.create!(
      name: "My Inventory"
    )

    post login_url, params: {
      email: @owner.email,
      password: "Secret123!"
    }
  end

  test "owner can grant write access using email" do
    assert_difference("InventoryAccess.count", 1) do
      post inventory_inventory_accesses_url(@inventory), params: {
        user_identifier: @target_user.email
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
    assert @inventory.users_with_write_access.exists?(@target_user.id)
  end

  test "owner can grant write access using exact name" do
    assert_difference("InventoryAccess.count", 1) do
      post inventory_inventory_accesses_url(@inventory), params: {
        user_identifier: @target_user.name
      }
    end

    assert @inventory.users_with_write_access.exists?(@target_user.id)
  end

  test "owner can revoke write access" do
    access = @inventory.inventory_accesses.create!(user: @target_user)

    assert_difference("InventoryAccess.count", -1) do
      delete inventory_inventory_access_url(@inventory, access)
    end

    assert_redirected_to edit_inventory_path(@inventory)
  end

  test "owner cannot grant write access to the same user twice" do
    @inventory.inventory_accesses.create!(user: @target_user)

    assert_no_difference("InventoryAccess.count") do
      post inventory_inventory_accesses_url(@inventory), params: {
        user_identifier: @target_user.email
      }
    end
  end

  test "owner cannot grant access to an unknown user" do
    assert_no_difference("InventoryAccess.count") do
      post inventory_inventory_accesses_url(@inventory), params: {
        user_identifier: "unknown@example.com"
      }
    end
  end

  test "owner cannot grant access using an ambiguous name" do
    duplicate_user = User.create!(
      name: @target_user.name,
      email: "another-sara@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    assert_no_difference("InventoryAccess.count") do
      post inventory_inventory_accesses_url(@inventory), params: {
        user_identifier: @target_user.name
      }
    end
  end

  test "another user cannot grant write access" do
    other_inventory = @target_user.inventories.create!(
      name: "Other Inventory"
    )

    assert_no_difference("InventoryAccess.count") do
      post inventory_inventory_accesses_url(other_inventory), params: {
        user_identifier: @owner.email
      }
    end

    assert_redirected_to inventories_path
  end

  test "another user cannot revoke write access" do
    access = @inventory.inventory_accesses.create!(user: @target_user)

    post logout_url
    post login_url, params: {
      email: @target_user.email,
      password: "Secret123!"
    }

    assert_no_difference("InventoryAccess.count") do
      delete inventory_inventory_access_url(@inventory, access)
    end

    assert_redirected_to inventories_path
    assert InventoryAccess.exists?(access.id)
  end

  test "admin can grant write access" do
    admin = User.create!(
      name: "Admin",
      email: "admin@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!",
      role: "admin"
    )

    post logout_url
    post login_url, params: {
      email: admin.email,
      password: "Secret123!"
    }

    assert_difference("InventoryAccess.count", 1) do
      post inventory_inventory_accesses_url(@inventory), params: {
        user_identifier: @target_user.email
      }
    end
  end
end
