require "datetime"
class PostsController < ApplicationController
  def index
    if !current_user
      redirect_to new_user_session_path
    else
      @post = Post.new
      @posts = Post.all.order(:created_at).reverse_order
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
