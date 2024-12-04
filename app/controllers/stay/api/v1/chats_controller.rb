class Stay::Api::V1::ChatsController < ApplicationController
  before_action :authenticate_devise_api_token!

  def index
    chats = chats = Stay::Chat.joins(:messages, :property).where(stay_properties: { user_id: current_devise_api_user&.id }).order_by_latest_messages.uniq
    if chats.any?
      data = {
        message: "Chats Found",
        chats: ActiveModelSerializers::SerializableResource.new(chats, each_serializer: ChatSerializer, scope: { current_user: current_devise_api_user }),
        success: true
      }
      render json: { data: data }, status: :ok
    else
      render json: { error: "No chats found", success: false }, status: :unprocessable_entity
    end
  end

  def create
    begin
      @chat = Stay::Chat.between(current_devise_api_user&.id, params[:receiver_id]).create!(chat_params.merge(sender_id: current_devise_api_user&.id))
      render json: {
        data: "Chat Created",
        chat: ActiveModelSerializers::SerializableResource.new(@chat, serializer: ChatSerializer, scope: { current_user: current_devise_api_user }),
        success: true
      }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message, success: false }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: "An error occurred: #{e.message}", success: false }, status: :internal_server_error
    end
  end

  def user_chat
    @chats = Stay::Chat.for_user(current_devise_api_user)
    if params[:unread].present?
      @chats = @chats.get_unread_messages_chat.order_by_latest_messages.uniq
    else
      @chats = @chats.get_all_messages.order_by_latest_messages.uniq
    end

    data = {
      message: @chats.any? ? "Chats Found" : "No Chat Found",
      chats: @chats.any? ? ActiveModelSerializers::SerializableResource.new(@chats, each_serializer: ChatSerializer, scope: { current_user: current_devise_api_user }) : [],
      success: @chats.any? ? true : false
    }
    render json: { data: data }, status: :ok
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
    params.require(:chat).permit(:sender_id, :receiver_id, :property_id, :booking_id, :chat_event, :event_message)
  end
end
