class FriendshipsController < ApplicationController
  def create
    @new_friend = User.find(params[:friend_id])
    @friendship = current_user.friendships.build(friend: @new_friend)
    if @friendship.save
      flash[:notice] = "You have successfully added #{@new_friend.username} as a
      friend."

      redirect_to root_path
    end
  end

  def index
    authenticate_user!

    @current_user = current_user
    @user = User.find(params[:user_id])

    @friends = []
    Friendship.where(user: @user, confirmed: true).each do |friendship|
      @friends << [friendship.friend, friendship]
    end
    Friendship.where(friend: @user, confirmed: true).each do |friendship|
      @friends << [friendship.user, friendship]
    end
    @friends.sort!

    @friend_requests = []
    Friendship.where(friend: @user, confirmed: false).each do |friendship|
      @friend_requests << [friendship.user, friendship]
    end
    @friend_requests.sort!

    @pending_friendships = []
    Friendship.where(user: @user, confirmed: false).each do |friendship|
      @pending_friendships << [friendship.friend, friendship]
    end
    @pending_friendships.sort!
  end

  def update
    authenticate_user!
    user = current_user
    friendship = Friendship.find(params[:id])
    if user.inverse_friendships.update(params[:id], { confirmed: true })
      flash[:notice] = "You and #{ friendship.user.username } are now friends."
      redirect_to user_friendships_path(current_user)
    end
  end

  def destroy
    @user = current_user
    friendship = Friendship.find(params[:id])

    if friendship.user == @user
      @friend = friendship.friend
    else
      @friend = friendship.user
    end
    if friendship.destroy
      flash[:notice] = "#{@friend.username} was successfully removed from your
                       friends"
      redirect_to user_friendships_path(@user)
    end
  end
end
