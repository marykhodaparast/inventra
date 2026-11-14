class CustomFieldsController < ApplicationController
  before_action :set_inventory
  before_action :require_manage_access
  before_action :set_custom_field, only: [:update, :destroy]

  def create
    @custom_field = @inventory.custom_fields.new(custom_field_params)
    @custom_field.position = @inventory.custom_fields.maximum(:position).to_i + 1

    if @custom_field.save
      redirect_to edit_inventory_path(@inventory),
                  notice: "Custom field created successfully."
    else
      redirect_to edit_inventory_path(@inventory),
                  alert: @custom_field.errors.full_messages.to_sentence
    end
  end

  def update
    if @custom_field.update(custom_field_params)
      redirect_to edit_inventory_path(@inventory),
                  notice: "Custom field updated successfully."
    else
      redirect_to edit_inventory_path(@inventory),
                  alert: @custom_field.errors.full_messages.to_sentence
    end
  end

  def destroy
    @custom_field.destroy

    redirect_to edit_inventory_path(@inventory),
                notice: "Custom field deleted successfully."
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

  def set_custom_field
    @custom_field = @inventory.custom_fields.find(params[:id])
  end

  def custom_field_params
    params.require(:custom_field).permit(:name, :field_type)
  end
end
