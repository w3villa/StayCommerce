class Stay::Api::V1::MessagesController < Stay::BaseApiController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :authenticate_devise_api_token!
  before_action :set_chat

  def index
    begin
      @messages = @chat.messages

      render json: {
        data: "Messages Found",
        chat: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer),
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
      message = Stay::Message.new(message_params)
      message.chat_id = params[:chat_id]

      if message.save
        ActionCable.server.broadcast "ChatChannel", message
        render json: {
          data: "Message Created",
          message: ActiveModelSerializers::SerializableResource.new(message, each_serializer: MessageSerializer),
          success: true
        }, status: :created
      else
        render json: { error: message.errors.full_messages.join(', '), success: false }, status: :unprocessable_entity
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
