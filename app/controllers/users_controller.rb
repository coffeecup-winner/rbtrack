class UsersController < ApplicationController
  before_filter :not_signed_in_user, only: [:new, :create]
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def new
    @user = User.new
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the rbTrack!'
      redirect_to @user
    else
      render :new
    end
  end
  def show
    @user = User.find(params[:id])
  end
  def index
    @users = User.paginate(page: params[:page])
  end
  def edit
  end
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated'
      sign_in @user
      redirect_to @user
    else
      render :edit
    end
  end
  def destroy
    user = User.find(params[:id])
    if current_user?(user)
      redirect_to root_path
    else
      user.destroy
      flash[:success] = "User #{user.name} with email address #{user.email} have been deleted."
      redirect_to users_path
    end
  end

private
  def not_signed_in_user
    redirect_to root_path unless !signed_in?
  end
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end
end
