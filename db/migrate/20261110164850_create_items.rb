class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.references :inventory, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
