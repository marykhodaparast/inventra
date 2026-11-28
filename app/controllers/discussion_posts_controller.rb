class DiscussionPostsController < ApplicationController
  before_action :require_login, only: :create

  def index
  @inventory = Inventory.find(params[:inventory_id])

  @discussion_posts = @inventory.discussion_posts
                               .includes(:user, :discussion_post_likes)
                               .order(created_at: :asc)

  render partial: "discussion_posts/posts",
         locals: { discussion_posts: @discussion_posts }
  end

  def create
    @inventory = Inventory.find(params[:inventory_id])

    @discussion_post = @inventory.discussion_posts.new(
      discussion_post_params.merge(user: current_user)
    )

    if @discussion_post.save
      redirect_to inventory_items_path(@inventory),
                  notice: "Message posted successfully."
    else
      redirect_to inventory_items_path(@inventory),
                  alert: "Message could not be posted."
    end
  end

  private

  def discussion_post_params
    params.require(:discussion_post).permit(:content)
  end
end
