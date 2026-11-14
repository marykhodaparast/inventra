class InventoryAccessesController < ApplicationController
  before_action :set_inventory
  before_action :require_manage_access
  before_action :set_inventory_access, only: :destroy

  def create
    identifier = params[:user_identifier].to_s.strip.downcase

    matches = User.where(
      "LOWER(email) = :identifier OR LOWER(name) = :identifier",
      identifier: identifier
    )

    if identifier.blank? || matches.count != 1
      redirect_to edit_inventory_path(@inventory),
                  alert: "User not found or name is ambiguous."
      return
    end

    target_user = matches.first

    if target_user.id == @inventory.user_id
      redirect_to edit_inventory_path(@inventory),
                  alert: "The inventory owner already has access."
      return
    end

    access = @inventory.inventory_accesses.new(user: target_user)

    if access.save
      redirect_to edit_inventory_path(@inventory),
                  notice: "Write access granted successfully."
    else
      redirect_to edit_inventory_path(@inventory),
                  alert: access.errors.full_messages.to_sentence
    end
  end

  def destroy
    @inventory_access.destroy

    redirect_to edit_inventory_path(@inventory),
                notice: "Write access revoked successfully."
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

  def set_inventory_access
    @inventory_access = @inventory.inventory_accesses.find(params[:id])
  end
end
