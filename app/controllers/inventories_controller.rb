class InventoriesController < ApplicationController
  before_action :require_login, only: [:new, :create]
  before_action :set_inventory, only: [:edit, :update, :destroy]
  before_action :require_manage_access, only: [:edit, :update, :destroy]
  before_action :load_edit_data, only: [:edit, :update]

  def index
    @inventories = Inventory.includes(:user).order(created_at: :desc)
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
    @inventory = Inventory.find(params[:id])
  end

  def load_edit_data
  @inventory_accesses = @inventory.inventory_accesses
                                   .joins(:user)
                                   .includes(:user)
                                   .order("users.name ASC, users.email ASC")

  existing_user_ids = @inventory.inventory_accesses.pluck(:user_id)

  @available_users = User.where.not(
    id: existing_user_ids + [@inventory.user_id]
  ).order(:name, :email)
end

  def require_manage_access
    return if current_user&.admin? || @inventory.user_id == current_user&.id

    if current_user.nil?
      redirect_to login_path, alert: "Please log in to continue."
    else
      redirect_to inventories_path,
                  alert: "You don't have permission to manage this inventory."
    end
  end

  def inventory_params
    params.require(:inventory).permit(:name, :description, :visibility)
  end
end
