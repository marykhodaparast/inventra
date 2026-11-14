class CategoriesController < ApplicationController
  before_action :set_inventory
  before_action :require_manage_access
  before_action :set_category, only: [:update, :destroy]

  def create
    @category = @inventory.categories.new(category_params)

    if @category.save
      redirect_to edit_inventory_path(@inventory),
                  notice: "Category created successfully."
    else
      redirect_to edit_inventory_path(@inventory),
                  alert: @category.errors.full_messages.to_sentence
    end
  end

  def update
    if @category.update(category_params)
      redirect_to edit_inventory_path(@inventory),
                  notice: "Category updated successfully."
    else
      redirect_to edit_inventory_path(@inventory),
                  alert: @category.errors.full_messages.to_sentence
    end
  end

  def destroy
    @category.destroy

    redirect_to edit_inventory_path(@inventory),
                notice: "Category deleted successfully."
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:inventory_id])
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

  def set_category
    @category = @inventory.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
