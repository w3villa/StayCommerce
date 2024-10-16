class Stay::Api::V1::MessagesController < Stay::BaseApiController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :authenticate_devise_api_token!
  before_action :set_chat

  def index
    begin
      @messages = @chat.messages

      render json: {
        data: "Messages Found",
        chat: ActiveModelSerializers::SerializableResource.new(@chat, serializer: ChatSerializer),
        message: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer),
        success: true
      }, status: :ok
    rescue StandardError => e
      render json: { error: e.message, success: false }, status: :internal_server_error
    end
  end

  def new
    @message = @chat.messages.new
    render json: { data: "Message form loaded", message: @message, success: true }, status: :ok
  rescue StandardError => e
    render json: { error: e.message, success: false }, status: :internal_server_error
  end

  def create
    begin
      sender_id = @chat.sender_id
      receiver_id = @chat.receiver_id

      message = @chat.messages.new(message_params)
      message.sender_id = current_devise_api_user.id
      message.chat_id = params[:chat_id]

      if message.sender_id == sender_id
        message.receiver_id = receiver_id
      elsif message.sender_id == receiver_id
        message.receiver_id = sender_id
      else
        return render json: { error: "Invalid sender or receiver", success: false }, status: :unprocessable_entity
      end

      return render json: { error: "You cannot send a message to yourself", success: false }, status: :unprocessable_entity if message.sender_id == message.receiver_id

      if message.save
        ActionCable.server.broadcast "ChatChannel", message
        render json: {
          data: "Message Created",
          chat: ActiveModelSerializers::SerializableResource.new(@chat, serializer: ChatSerializer),
          message: ActiveModelSerializers::SerializableResource.new(message, each_serializer: MessageSerializer),
          success: true
        }, status: :created
      else
        render json: { error: message.errors.full_messages.join(", "), success: false }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Chat not found: #{e.message}", success: false }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message, success: false }, status: :internal_server_error
    end
  end

  private

  def set_chat
    begin
      @chat = Stay::Chat.find(params[:chat_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Chat not found: #{e.message}", success: false }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message, success: false }, status: :internal_server_error
    end
  end

  def message_params
    params.require(:message).permit(:body, :sender_id, :receiver_id)
  end
end
