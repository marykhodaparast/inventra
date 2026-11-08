class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @users = User.order(:id)
  end

  def update
    @user = User.find(params[:id])

    if @user.admin? &&
   params[:user][:role] == "user" &&
   User.where(role: "admin").count == 1

  redirect_to admin_users_path,
              alert: "The last admin cannot be demoted."
  return
    end

    if @user.update(role_params)
      redirect_to admin_users_path, notice: "User role updated successfully!"
    else
      redirect_to admin_users_path, alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def role_params
    params.require(:user).permit(:role)
  end
end
