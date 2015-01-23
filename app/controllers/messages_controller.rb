def confirmed_friends(user)
  confirmed_friends = []
  user.friendships.each do |friendship|
    if friendship.confirmed?
      confirmed_friends << friendship.friend
    end
  end
  user.inverse_friendships.each do |friendship|
    if friendship.confirmed?
      confirmed_friends << friendship.user
    end
  end
  confirmed_friends
end

class MessagesController < ApplicationController
  include EncryptionHelper
  def new
    @message = Message.new
    @recipient_options = confirmed_friends(current_user)
  end

  def create
    @recipient_options = confirmed_friends(current_user)
    @message = Message.new(message_params)
    if !@message.body.empty?
      @message.body = encrypt(@message.body, @message.public_key_m, @message.public_key_k)
    end
    @message.sender = current_user

    if @message.public_key_m != @message.recipient.public_key_m ||
       @message.public_key_k != @message.recipient.public_key_k
       flash[:error] = "Public keys must match recipient's public keys"
       render :new
    elsif @message.save
      flash[:notice] = "Your message has been sent."
      redirect_to root_path
    else
      render :new
    end
  end
  def index
  end

  private

  def message_params
    params.require(:message).permit(:body, :recipient_id, :public_key_m, :public_key_k)
  end
end
