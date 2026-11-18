class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
  @user = current_user

  attributes = profile_params
  @user.assign_attributes(attributes)

  if @user.save
    redirect_to profile_path, notice: "Profile updated successfully!"
  else
    render :edit, status: :unprocessable_entity
  end
end

  private

  def profile_params
  params.require(:user).permit(
    :name,
    :email,
    :bio,
    :avatar_url,
    :theme
  )
  end
end
