module PostHelper
  def friends_post?(post)
    Friendship.where(user: current_user, confirmed: true).each do |friendship|
      if post.user == friendship.friend
        return true
      end
    end
    Friendship.where(friend: current_user, confirmed: true).each do |friendship|
      if post.user == friendship.user
        return true
      end
    end
    false
  end
  
  def friends_message?(message)
    Friendship.where(user: current_user, confirmed: true).each do |friendship|
      if message.sender == friendship.friend
        return true
      end
    end
    Friendship.where(friend: current_user, confirmed: true).each do |friendship|
      if message.sender == friendship.user
        return true
      end
    end
    false
  end
end
