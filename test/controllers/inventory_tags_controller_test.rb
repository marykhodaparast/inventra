require "test_helper"

class InventoryTagsControllerTest < ActionDispatch::IntegrationTest
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

  test "owner can add a tag to inventory" do
    assert_difference("Tag.count", 1) do
      assert_difference("InventoryTag.count", 1) do
        post inventory_inventory_tags_url(@inventory), params: {
          tag_name: "Technology"
        }
      end
    end

    assert_redirected_to edit_inventory_path(@inventory)
    assert_includes @inventory.tags.pluck(:name), "technology"
  end

  test "owner cannot create duplicate tag for same inventory" do
    tag = Tag.create!(name: "technology")
    @inventory.tags << tag

    assert_no_difference("Tag.count") do
      assert_no_difference("InventoryTag.count") do
        post inventory_inventory_tags_url(@inventory), params: {
          tag_name: "TECHNOLOGY"
        }
      end
    end
  end

  test "owner cannot add a blank tag" do
    assert_no_difference("Tag.count") do
      post inventory_inventory_tags_url(@inventory), params: {
        tag_name: "   "
      }
    end

    assert_redirected_to edit_inventory_path(@inventory)
  end

  test "owner can remove a tag from inventory" do
    tag = Tag.create!(name: "technology")
    inventory_tag = @inventory.inventory_tags.create!(tag: tag)

    assert_difference("InventoryTag.count", -1) do
      delete inventory_inventory_tag_url(@inventory, inventory_tag)
    end

    assert_redirected_to edit_inventory_path(@inventory)
    assert Tag.exists?(tag.id)
  end

  test "user with write access cannot manage inventory tags" do
    @inventory.inventory_accesses.create!(user: @target_user)

    post logout_url
    post login_url, params: {
      email: @target_user.email,
      password: "Secret123!"
    }

    assert_no_difference("Tag.count") do
      post inventory_inventory_tags_url(@inventory), params: {
        tag_name: "technology"
      }
    end

    assert_redirected_to inventories_path
  end

  test "guest cannot add a tag" do
    delete logout_url

    assert_no_difference("Tag.count") do
      post inventory_inventory_tags_url(@inventory), params: {
        tag_name: "technology"
      }
    end

    assert_redirected_to login_path
  end
end
