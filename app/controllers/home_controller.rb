class HomeController < ApplicationController
  def index
    @latest_inventories = Inventory
      .includes(:user)
      .order(created_at: :desc)
      .limit(10)

    @popular_inventories = Inventory
      .left_joins(:items)
      .select("inventories.*, COUNT(items.id) AS items_count")
      .group("inventories.id")
      .order("items_count DESC")
      .limit(5)
      .includes(:user)

    @tags = Tag
      .joins(:inventories)
      .select("tags.*, COUNT(inventory_tags.inventory_id) AS inventories_count")
      .group("tags.id")
      .order("inventories_count DESC")
  end
end
