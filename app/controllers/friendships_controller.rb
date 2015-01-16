class FriendshipsController < ApplicationController
  def create
    @new_friend = User.find(params[:friend_id])
    @friendship = current_user.friendships.build(friend: @new_friend)
    if @friendship.save
      flash[:notice] = "You have successfully added #{@new_friend.username} as a
      friend. We'll let you know when they confirm your friendship"

      redirect_to root_path
    end
  end
end
