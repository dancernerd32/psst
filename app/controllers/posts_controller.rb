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

class PostsController < ApplicationController
  def index
    if !current_user
      redirect_to new_user_session_path
    else
      @post = Post.new
      @posts = []
      Post.all.order(:created_at).reverse_order.each do |post|
        if friends_post?(post)
          @posts << post
        elsif post.user == current_user
          @posts << post
        end
      end
    end
  end

  def create
    authenticate_user!
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to posts_path
    else
      @posts = Post.all.order(:created_at).reverse_order
      render :index
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
