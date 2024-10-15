class Stay::Api::V1::ChatsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :authenticate_devise_api_token!


  def index
    chats = Stay::Chat.joins(:property).where(stay_properties: { user_id: current_devise_api_user&.id })  
    return render json: { error: "No chat found", success: false }, status: :unprocessable_entity  if chats.none?
    render json: {
      data: "Chats Found",
      chats: ActiveModelSerializers::SerializableResource.new(chats, each_serializer: ChatSerializer),
      success: true
    }, status: :ok
  end

  def create
    def create
      begin
        @chat = Stay::Chat.between(params[:sender_id], params[:receiver_id]).first_or_create!(chat_params)
          render json: {
          data: "Chat Created",
          chat: ActiveModelSerializers::SerializableResource.new(@chat, serializer: ChatSerializer),
          success: true
        }, status: :ok
      rescue ActiveRecord::RecordInvalid => e
        render json: {
          error: e.message,
          success: false
        }, status: :unprocessable_entity
      rescue StandardError => e
        render json: {
          error: "An error occurred: #{e.message}",
          success: false
        }, status: :internal_server_error
      end
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
