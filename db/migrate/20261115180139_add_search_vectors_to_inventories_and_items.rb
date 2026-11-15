class AddSearchVectorsToInventoriesAndItems < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      ALTER TABLE inventories
      ADD COLUMN search_vector tsvector
      GENERATED ALWAYS AS (
        to_tsvector(
          'english',
          coalesce(name, '') || ' ' ||
          coalesce(description, '') || ' ' ||
          coalesce(custom_id, '')
        )
      ) STORED;
    SQL

    execute <<~SQL
      ALTER TABLE items
      ADD COLUMN search_vector tsvector
      GENERATED ALWAYS AS (
        to_tsvector(
          'english',
          coalesce(name, '') || ' ' ||
          coalesce(description, '')
        )
      ) STORED;
    SQL

    add_index :inventories, :search_vector, using: :gin
    add_index :items, :search_vector, using: :gin
  end

  def down
    remove_index :inventories, :search_vector
    remove_index :items, :search_vector

    remove_column :inventories, :search_vector
    remove_column :items, :search_vector
  end
end
