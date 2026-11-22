class InventoryTagsController < ApplicationController
  before_action :require_login
  before_action :set_inventory
  before_action :require_manage_access

  def create
  tag_name = params[:tag_name].to_s.strip.downcase

  if tag_name.blank?
    redirect_to edit_inventory_path(@inventory),
                alert: "Tag name cannot be blank."
    return
  end

  tag = Tag.find_or_create_by!(name: tag_name)

  @inventory.inventory_tags.find_or_create_by!(tag: tag)

  redirect_to edit_inventory_path(@inventory),
              notice: "Tag added successfully."
end
  def destroy
    inventory_tag = @inventory.inventory_tags.find(params[:id])

    if inventory_tag.destroy
      redirect_to edit_inventory_path(@inventory),
                  notice: "Tag removed successfully."
    else
      redirect_to edit_inventory_path(@inventory),
                  alert: inventory_tag.errors.full_messages.to_sentence.presence ||
                         "Tag could not be removed."
    end
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:inventory_id])
  end

  def require_manage_access
    return if current_user&.admin? || @inventory.user_id == current_user&.id

    redirect_to inventories_path,
                alert: "You don't have permission to manage this inventory."
  end
end
