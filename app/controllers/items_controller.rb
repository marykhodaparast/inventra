class ItemsController < ApplicationController
  before_action :require_login
  before_action :set_inventory
  before_action :set_item, only: [ :show, :edit, :update, :destroy ]

  def index
    @items = @inventory.items.order(created_at: :desc)
  end

  def new
    @item = @inventory.items.new
  end

  def create
    @item = @inventory.items.new(item_params)

    if @item.save
      redirect_to inventory_item_path(@inventory, @item),
      notice: "Item created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to inventory_item_path(@inventory, @item),
                notice: "Item updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy

    redirect_to inventory_items_path(@inventory),
    notice: "Item deleted successfully."
  end

  private

  def set_inventory
    @inventory = current_user.inventories.find(params[:inventory_id])
  end

  def set_item
    @item = @inventory.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :category_id)
  end
end
