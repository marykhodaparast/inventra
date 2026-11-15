class AddSearchVectorToCategories < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      ALTER TABLE categories
      ADD COLUMN search_vector tsvector
      GENERATED ALWAYS AS (
        to_tsvector(
          'english',
          coalesce(name, '')
        )
      ) STORED;
    SQL

    add_index :categories, :search_vector, using: :gin
  end

  def down
    remove_index :categories, :search_vector
    remove_column :categories, :search_vector
  end
end
