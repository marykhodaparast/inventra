class InventoriesController < ApplicationController
  before_action :require_login
  before_action :set_inventory, only: [:edit, :update, :destroy]

  def index
    @inventories = current_user.inventories.order(created_at: :desc)
  end

  def new
    @inventory = current_user.inventories.new
  end

  def create
    @inventory = current_user.inventories.new(inventory_params)

    if @inventory.save
      redirect_to inventories_path, notice: "Inventory created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to inventories_path, notice: "Inventory updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory.destroy
    redirect_to inventories_path, notice: "Inventory deleted successfully."
  end

  private

  def set_inventory
    @inventory = current_user.inventories.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:name, :description, :visibility)
  end
end
