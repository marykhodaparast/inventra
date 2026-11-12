class AddCustomFieldValuesToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :custom_field_values, :jsonb,
               null: false, default: {}
  end
end
