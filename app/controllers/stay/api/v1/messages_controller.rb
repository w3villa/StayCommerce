class Stay::Api::V1::MessagesController <  ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # skip_before_action :verify_authenticity_token

  before_action do
      @chat = Stay::Chat.find(params[:chat_id])
  end

  def index
    @messages = @chat.messages

    render json: {
      data: "Message Found",
      chat:ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer),
      success: true
     }, status: :ok
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
    render json: {
      data: "Message Create",
      chat:ActiveModelSerializers::SerializableResource.new(message, each_serializer: MessageSerializer),
      success: true
     }, status: :created
  end


  private

  def message_params
      params.require(:message).permit(:body, :user_id)
  end
end
