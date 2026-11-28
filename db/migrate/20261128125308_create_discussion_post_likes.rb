
class CreateDiscussionPostLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :discussion_post_likes do |t|
      t.references :discussion_post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :discussion_post_likes,
              [:discussion_post_id, :user_id],
              unique: true,
              name: "index_discussion_post_likes_on_post_and_user"
  end
end
