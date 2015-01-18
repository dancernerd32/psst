class FriendshipsController < ApplicationController
  def create
    @new_friend = User.find(params[:friend_id])
    @friendship = current_user.friendships.build(friend: @new_friend)
    if @friendship.save
      flash[:notice] = "You have successfully added #{@new_friend.username} as a
      friend. We'll let you know when they confirm your friendship"

      redirect_to root_path
    end

    def index
      authenticate_user!
      @current_user = current_user
      @user = User.find(params[:user_id])
      @friends = []
      if @user.friendships
        @user.friendships.each do |friend|
          if friend.confirmed?
            @friends << [friend.friend, friend]
          end
        end
        @user.inverse_friendships.each do |friend|
          if friend.confirmed?
            @friends << [friend.user, friend]
          end
        end
        @friends.sort!
      end

      @friend_requests = []
      if @user.inverse_friendships

        @user.inverse_friendships.each do |friend|
          if !friend.confirmed?
            @friend_requests << [friend.user, friend]
          end
        end
        @friend_requests.sort!
      end

      @pending_friendships = []
      if @user.friendships

        @user.friendships.each do |friend|
          if !friend.confirmed?
            @pending_friendships << [friend.friend, friend]
          end
        end
        @pending_friendships.sort!
      end
    end
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
