class ProfilesController < ApplicationController
  before_action :set_profile
  before_action :owned_profile, only: [:edit, :update]

  def show
    @posts = User.find_by(user_name: params[:user_name]).posts.order('created_at DESC')
  end

  def edit
  end

  def update
    @user = User.find_by(user_name: params[:user_name])
    if @user.update(profile_params)
      flash[:success] = 'Your profile has been updated.'
      redirect_to profile_path(@user.user_name)
    else
      @user.errors.full_messages
      flash[:error] = @user.errors.full_messages
      render :edit
    end
  end

  def following
    @title = "Following"
    @users = @user.following.page params[:page]
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers.page params[:page]
    render 'show_follow'
  end

  private

  def set_profile
    @user = User.find_by(user_name: params[:user_name])
  end

  def profile_params
    params.require(:user).permit(:avatar, :bio)
  end

  def owned_profile
    @user = User.find_by(user_name: params[:user_name])
    unless current_user == @user
      flash[:alert] = "That profile doesn't belong to you!"
      redirect_to root_path
    end
  end
end
