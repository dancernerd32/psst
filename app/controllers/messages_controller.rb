
class MessagesController < ApplicationController
  include EncryptionHelper
  def new
    @message = Message.new
    @recipient_options = []
    current_user.friends.each do |friend|
      @recipient_options << friend
    end
    current_user.inverse_friends.each do |friend|
      @recipient_options << friend
    end
  end

  def create
    @message = Message.new(message_params)
    @message.body = encrypt(@message.body, @message.public_key_m, @message.public_key_k)
    @message.sender = current_user
    if @message.save
      flash[:notice] = "Your message has been sent."
    end
    redirect_to root_path
  end
  def index
  end

  private

  def message_params
    params.require(:message).permit(:body, :recipient_id, :public_key_m, :public_key_k)
  end
end
