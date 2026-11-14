require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
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

    post login_url, params: {
      email: @user.email,
      password: "Secret123!"
    }
  end

  test "should create category" do
    assert_difference("Category.count", 1) do
      post inventory_categories_url(@inventory), params: {
        category: { name: "Books" }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
    assert_equal "Books", @inventory.categories.last.name
  end

  test "should update category" do
    category = @inventory.categories.create!(name: "Books")

    patch inventory_category_url(@inventory, category), params: {
      category: { name: "Programming Books" }
    }

    assert_redirected_to edit_inventory_path(@inventory)
    assert_equal "Programming Books", category.reload.name
  end

  test "should destroy category" do
    category = @inventory.categories.create!(name: "Books")

    assert_difference("Category.count", -1) do
      delete inventory_category_url(@inventory, category)
    end

    assert_redirected_to edit_inventory_path(@inventory)
    assert_not Category.exists?(category.id)
  end

  test "should not allow user to access another user's inventory categories" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    assert_no_difference("Category.count") do
      post inventory_categories_url(other_inventory), params: {
        category: { name: "Unauthorized Category" }
      }
    end

    assert_redirected_to inventories_path
  end

  test "should not create category with duplicate name in the same inventory" do
    @inventory.categories.create!(name: "Books")

    assert_no_difference("Category.count") do
      post inventory_categories_url(@inventory), params: {
        category: { name: "Books" }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
  end

  test "should not create category with blank name" do
    assert_no_difference("Category.count") do
      post inventory_categories_url(@inventory), params: {
        category: { name: "" }
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
  end

  test "should not update category with blank name" do
    category = @inventory.categories.create!(name: "Books")

    patch inventory_category_url(@inventory, category), params: {
      category: { name: "" }
    }

    assert_redirected_to edit_inventory_path(@inventory)
    assert_equal "Books", category.reload.name
  end

  test "should not allow user to update another user's category" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    category = other_inventory.categories.create!(name: "Private Category")

    assert_no_changes -> { category.reload.name } do
      patch inventory_category_url(other_inventory, category), params: {
        category: { name: "Hacked Category" }
      }
    end

    assert_redirected_to inventories_path
  end

  test "should not allow user to delete another user's category" do
    other_user = User.create!(
      name: "Other User",
      email: "other@example.com",
      password: "Secret123!",
      password_confirmation: "Secret123!"
    )

    other_inventory = other_user.inventories.create!(
      name: "Other Inventory"
    )

    category = other_inventory.categories.create!(name: "Private Category")

    assert_no_difference("Category.count") do
      delete inventory_category_url(other_inventory, category)
    end

    assert_redirected_to inventories_path
    assert Category.exists?(category.id)
  end
  test "should allow same category name in different inventories" do
  other_inventory = @user.inventories.create!(
    name: "Second Inventory"
  )

  @inventory.categories.create!(name: "Books")

  assert_difference("Category.count", 1) do
    post inventory_categories_url(other_inventory), params: {
      category: { name: "Books" }
    }
  end

  assert_equal "Books", other_inventory.categories.last.name
end
test "should keep items when category is deleted" do
  category = @inventory.categories.create!(name: "Books")

  item = @inventory.items.create!(
    name: "Ruby Programming Book",
    category: category
  )

  assert_no_difference("Item.count") do
    delete inventory_category_url(@inventory, category)
  end

  item.reload

  assert_nil item.category_id
  assert Item.exists?(item.id)
end
end
