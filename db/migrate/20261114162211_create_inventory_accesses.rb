class CreateInventoryAccesses < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_accesses do |t|
      t.references :inventory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :inventory_accesses,
              [:inventory_id, :user_id],
              unique: true
  end
end
