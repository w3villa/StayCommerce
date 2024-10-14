class Stay::Api::V1::ChatsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # skip_before_action :verify_authenticity_token

  def index
    @chat = Stay::Chat.where(property_id: params[:property_id])

    render json: {
      data: "Chat Found",
      chat:ActiveModelSerializers::SerializableResource.new(@chat, each_serializer: ChatSerializer),
      success: true
     }, status: :ok
  end

  def create
    @chat = Stay::Chat.between(params[:sender_id], params[:receiver_id]).first_or_create!(chat_params)
    render json: {
      data: "Chat Create",
      chat:ActiveModelSerializers::SerializableResource.new(@chat, each_serializer: ChatSerializer),
      success: true
     }, status: :ok
  end

  def chat_messages
    @chat = Stay::Chat.find(params[:chat_id])

    if @chat.present?
      @messages = @chat.messages.map do |message|
        position = message.user_id == current_user.id ? "sender" : "reciever"
        message.attributes.merge(position: position)
      end
      render json: {
        data: "Chat Create",
        chat:ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: ChatSerializer),
        success: true
      }, status: :ok
    else
      render json: { error: "Conversation not found" }, status: :not_found
    end
  end

  # def update_conversation_status
  #   @chat = Stay::Chat.find(params[:id])
  #   @chat.messages&.where.not(user_id: current_user.id).where(read: false).update_all(read: true) if @chat
  #   render json: true
  # end

  private

  def chat_params
    params.require(:chat).permit(:sender_id, :receiver_id, :property_id)
  end
end
