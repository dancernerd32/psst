
class MessagesController < ApplicationController
  include EncryptionHelper
  def new
    @message = Message.new
    # @recipient_options = User.friends.map{|u| [ u.username, u.id ] }
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
