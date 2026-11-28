
class DiscussionPostLikesController < ApplicationController
  before_action :require_login

  def create
    @inventory = Inventory.find(params[:inventory_id])
    @discussion_post = @inventory.discussion_posts.find(params[:discussion_post_id])

    @discussion_post.discussion_post_likes.find_or_create_by!(user: current_user)

    redirect_to inventory_items_path(@inventory),
                notice: "Post liked successfully."
  end

  def destroy
    @inventory = Inventory.find(params[:inventory_id])
    @discussion_post = @inventory.discussion_posts.find(params[:discussion_post_id])

    @discussion_post.discussion_post_likes.find_by(user: current_user)&.destroy

    redirect_to inventory_items_path(@inventory),
                notice: "Like removed successfully."
  end
end
