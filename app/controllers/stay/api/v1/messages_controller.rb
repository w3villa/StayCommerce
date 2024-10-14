class Stay::Api::V1::MessagesController <  ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # skip_before_action :verify_authenticity_token

  before_action do
      @chat = Stay::Chat.find(params[:chat_id])
  end

  def index
    @messages = @chat.messages
    @message = @chat.messages.new

    render json: @messages
  end

  def new
      @message = @chat.messages.new
  end

  def create
    @chat = Stay::Chat.find(params["chat_id"])
    message = Stay::Message.create(
      body: params["body"],
      sender_id: params[:sender_id],
      receiver_id: params[:receiver_id],
      chat_id: params[:chat_id],

    )
    if message.valid?
      ActionCable.server.broadcast "ChatChannel", message
    end
    render json: message
  end


  private

  def message_params
      params.require(:message).permit(:body, :user_id)
  end
end
