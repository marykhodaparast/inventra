class AddProfileAndRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :bio, :text
    add_column :users, :avatar_url, :string
    add_column :users, :role, :string, default: "user", null: false
  end
end
