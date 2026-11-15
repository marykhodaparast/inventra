class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @tag = Tag.find_by(name: params[:tag].to_s.strip.downcase) if params[:tag].present?

    if @tag
      @inventories = @tag.inventories.includes(:user)
      @items = Item.none
    else
      @inventories = Inventory.search(@query).includes(:user)
      @items = Item.search(@query).includes(:inventory)
    end
  end
end
