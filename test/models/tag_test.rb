require "test_helper"

class TagTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "Tag User",
      email: "tag-user@example.com",
      password: "password123"
    )

    @first_inventory = @user.inventories.create!(
      name: "First Inventory"
    )

    @second_inventory = @user.inventories.create!(
      name: "Second Inventory"
    )
  end

  test "should create a tag with a valid name" do
    tag = Tag.create!(name: "Technology")

    assert_equal "technology", tag.name
  end

  test "should normalize tag name" do
    tag = Tag.create!(name: "  Technology  ")

    assert_equal "technology", tag.name
  end

  test "should not allow duplicate tag names regardless of case" do
    Tag.create!(name: "Technology")

    duplicate_tag = Tag.new(name: "TECHNOLOGY")

    assert_not duplicate_tag.valid?
    assert_includes duplicate_tag.errors[:name], "has already been taken"
  end

  test "tag can belong to multiple inventories" do
    tag = Tag.create!(name: "Technology")

    @first_inventory.tags << tag
    @second_inventory.tags << tag

    assert_includes @first_inventory.tags, tag
    assert_includes @second_inventory.tags, tag
    assert_equal 2, tag.inventories.count
  end

  test "should not allow a tag without a name" do
    tag = Tag.new(name: "")

    assert_not tag.valid?
    assert_includes tag.errors[:name], "can't be blank"
  end
  test "deleting an inventory preserves shared tags and other inventory associations" do
  tag = Tag.create!(name: "Technology")

  @first_inventory.tags << tag
  @second_inventory.tags << tag

  @first_inventory.destroy!

  assert Tag.exists?(tag.id)
  assert_equal [ @second_inventory.id ], tag.reload.inventories.pluck(:id)
  assert_equal [ tag.id ], @second_inventory.reload.tags.pluck(:id)
end
end
