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

  before_action :require_secret_keys, only: [:show]

  def new
    authenticate_user!
    @user = current_user
    @message = Message.new
    @recipient_options = confirmed_friends(current_user)
  end

  def create
    authenticate_user!
    @recipient_options = confirmed_friends(current_user)
    @message = Message.new(message_params)

    if !@message.body.empty?
      @message.body = encrypt(@message.body,
                              @message.public_key_m,
                              @message.public_key_k)
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
    authenticate_user!
    @user = current_user
    @secret_key_p = current_user.secret_key_p
    @secret_key_q = current_user.secret_key_q
    @messages = []
    Message.all.order(:created_at).reverse_order.each do |message|
      if message.recipient == current_user
        @messages << message
      end
    end
  end

  def show
    authenticate_user!
    message = Message.find(params[:id])
    @message = message.body
    @p = message.recipient.secret_key_p
    @q = message.recipient.secret_key_q
    @m = message.recipient.public_key_m
    @k = message.recipient.public_key_k
    @user = current_user
    @recipient = message.recipient
  end

  private

  def message_params
    params.require(:message).permit(:body,
                                    :recipient_id,
                                    :public_key_m,
                                    :public_key_k)
  end

  def require_secret_keys
    if current_user
      @user = current_user
      @secret_key_p = current_user.secret_key_p
      @secret_key_q = current_user.secret_key_q
      @messages = []
      Message.all.order(:created_at).reverse_order.each do |message|
        if message.recipient == current_user
          @messages << message
        end
      end
      if (!params[:secret_key_p] ||
         !params[:secret_key_q] ||
         params[:secret_key_p].to_i != @secret_key_p ||
         params[:secret_key_q].to_i != @secret_key_q)

        flash[:error] = "Secret keys are required"
        render :index
      end
    end
  end
end
