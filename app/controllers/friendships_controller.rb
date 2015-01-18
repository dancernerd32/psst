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
      @user = current_user
      # if current_user.friends || current_user.inverse_friends
      #   @friends = []
      #   current_user.friendships.each do |friend|
      #     if friend.confirmed?
      #       @friends << friend.friend
      #     end
      #   end
      #   current_user.inverse_friendships.each do |friend|
      #     if friend.confirmed?
      #       @friends << friend.user
      #     end
      #   end
      #   @friends.sort!
      # end

      if current_user.inverse_friends

        @friend_requests = []
        current_user.inverse_friendships.each do |friend|
          if !friend.confirmed?
            @friend_requests << [ friend.user, friend ]
          end
        end
        @friend_requests.sort!
      end
    end
  end

  def update
    authenticate_user!
    user = current_user
    friendship = Friendship.find(params[:id])
    if user.inverse_friendships.update(params[:id], {confirmed: true})
      flash[:notice] = "You and #{friendship.user.username} are now friends."
      redirect_to user_friendships_path(current_user)
    end
  end
end
