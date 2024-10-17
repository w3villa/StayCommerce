class Stay::Api::V1::ChatsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :authenticate_devise_api_token!

  def index
    chats = Stay::Chat.joins(:property).where(stay_properties: { user_id: current_devise_api_user&.id })

    if chats.any?
      render json: {
        data: "Chats Found",
        chats: ActiveModelSerializers::SerializableResource.new(chats, each_serializer: ChatSerializer),
        success: true
      }, status: :ok
    else
      render json: { error: "No chats found", success: false }, status: :unprocessable_entity
    end
  end

  def create
    begin
      @chat = Stay::Chat.between(current_devise_api_user&.id, params[:receiver_id]).first_or_create!(chat_params.merge(sender_id: current_devise_api_user&.id))
      render json: {
        data: "Chat Created",
        chat: ActiveModelSerializers::SerializableResource.new(@chat, serializer: ChatSerializer),
        success: true
      }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message, success: false }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: "An error occurred: #{e.message}", success: false }, status: :internal_server_error
    end
  end

  def user_chat
    @chats = Stay::Chat.where(sender_id: current_devise_api_user.id)
                       .or(Stay::Chat.where(receiver_id: current_devise_api_user.id))

    if @chats.any?
      users_with_chats = @chats.map do |chat|
        other_user_id = chat.sender_id == current_devise_api_user.id ? chat.receiver_id : chat.sender_id
        other_user = Stay::User.find_by(id: other_user_id)
        last_message = chat.messages.last
        {
          id: other_user&.id,
          email: other_user&.email,
          chat_id: chat.id,
          last_message: last_message&.body,
          last_message_created_at: last_message&.created_at
        }
      end
      render json: { data: users_with_chats, success: true }, status: :ok
    else
      render json: { data: [], success: false }, status: :ok
    end
  end

  def chat_messages
    begin
      @chat = Stay::Chat.find(params[:id])
      @messages = @chat.messages
      render json: { messages: @messages, success: true }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Chat not found", success: false }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message, success: false }, status: :internal_server_error
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:sender_id, :receiver_id, :property_id)
  end
end
