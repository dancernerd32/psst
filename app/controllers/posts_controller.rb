class PostsController < ApplicationController
  include PostHelper
  def index
    if !current_user
      redirect_to new_user_session_path
    else
      @post = Post.new
      @posts = []
      @messages = []
      Post.all.order(:created_at).reverse_order.each do |post|
        if friends_post?(post)
          @posts << post
        elsif post.user == current_user
          @posts << post
        end
      end
      Message.all.order(:created_at).reverse_order.each do |message|
        if friends_message?(message)
          @messages << message
        elsif message.sender == current_user
          @messages << message
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
