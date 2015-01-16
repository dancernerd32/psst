class UsersController < ApplicationController
  def index
    authenticate_user!
    @users = User.all
  end

  def show
    authenticate_user!
    @user = User.find(params[:id])
  end
end
