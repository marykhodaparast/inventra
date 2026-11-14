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

  test "inventory owner can write" do
  user = User.create!(
    name: "Owner",
    email: "owner@example.com",
    password: "password123"
  )

  inventory = user.inventories.create!(name: "Owner Inventory")

  assert inventory.writable_by?(user)
end

test "admin can write to another user's inventory" do
  owner = User.create!(
    name: "Owner",
    email: "owner2@example.com",
    password: "password123"
  )

  admin = User.create!(
    name: "Admin",
    email: "admin@example.com",
    password: "password123",
    role: "admin"
  )

  inventory = owner.inventories.create!(name: "Private Inventory")

  assert inventory.writable_by?(admin)
end
test "user with write access can write to private inventory" do
  owner = User.create!(
    name: "Owner",
    email: "owner3@example.com",
    password: "password123"
  )

  writer = User.create!(
    name: "Writer",
    email: "writer@example.com",
    password: "password123"
  )

  inventory = owner.inventories.create!(name: "Private Inventory")

  inventory.inventory_accesses.create!(user: writer)

  assert inventory.writable_by?(writer)
end

test "user without write access cannot write to private inventory" do
  owner = User.create!(
    name: "Owner",
    email: "owner4@example.com",
    password: "password123"
  )

  other_user = User.create!(
    name: "Other User",
    email: "other@example.com",
    password: "password123"
  )

  inventory = owner.inventories.create!(name: "Private Inventory")

  assert_not inventory.writable_by?(other_user)
end
test "any authenticated user can write to public inventory" do
  owner = User.create!(
    name: "Owner",
    email: "owner5@example.com",
    password: "password123"
  )

  other_user = User.create!(
    name: "Other User",
    email: "other2@example.com",
    password: "password123"
  )

  inventory = owner.inventories.create!(
    name: "Public Inventory",
    visibility: "public"
  )

  assert inventory.writable_by?(other_user)
end

test "guest cannot write to public inventory" do
  owner = User.create!(
    name: "Owner",
    email: "owner6@example.com",
    password: "password123"
  )

  inventory = owner.inventories.create!(
    name: "Public Inventory",
    visibility: "public"
  )

  assert_not inventory.writable_by?(nil)
end
end
