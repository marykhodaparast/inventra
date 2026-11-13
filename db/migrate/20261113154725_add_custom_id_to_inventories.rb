
class AddCustomIdToInventories < ActiveRecord::Migration[8.1]
  def up
    add_column :inventories, :custom_id, :string

    execute <<~SQL
      UPDATE inventories
      SET custom_id = 'INV-' || LPAD(id::text, 6, '0')
    SQL

    change_column_null :inventories, :custom_id, false

    add_index :inventories, :custom_id, unique: true
  end

  def down
    remove_index :inventories, :custom_id
    remove_column :inventories, :custom_id
  end
end
