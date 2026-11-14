class ItemsController < ApplicationController
  before_action :set_inventory
  before_action :require_write_access, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]

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

  def require_write_access
  unless @inventory.writable_by?(current_user)
    if current_user.nil?
      redirect_to login_path, alert: "Please log in to continue."
    else
      redirect_to inventory_items_path(@inventory),
                  alert: "You don't have permission to modify this inventory."
    end
  end
  end

  def set_inventory
    @inventory = Inventory.find(params[:inventory_id])
  end

  def set_item
    @item = @inventory.items.find(params[:id])
  end

  def item_params
  permitted_params = params.require(:item).permit(
    :name,
    :description,
    :category_id,
    custom_field_values: {}
  )

  if permitted_params.key?(:custom_field_values)
    allowed_ids = @inventory.custom_fields.pluck(:id).map(&:to_s)

    existing_values =
      if @item&.persisted?
        @item.custom_field_values.to_h.slice(*allowed_ids)
      else
        {}
      end

    permitted_params[:custom_field_values] =
      existing_values.merge(
        permitted_custom_field_values(permitted_params[:custom_field_values])
      )
  end

  permitted_params
end

def permitted_custom_field_values(values)
  return {} unless values.is_a?(ActionController::Parameters) ||
                   values.is_a?(Hash)

  allowed_ids = @inventory.custom_fields.pluck(:id).map(&:to_s)

  values.to_h.slice(*allowed_ids)
end
end
