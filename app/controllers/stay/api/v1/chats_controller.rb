class Stay::Api::V1::ChatsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # skip_before_action :verify_authenticity_token

  def index
    @users = Stay::User.all
    @chat = Stay::Chat.all
  end

  def current_logged_in_user
    unless current_user.present?
      head :no_content
      return
    end

    if current_user.user_type_family?
        response = current_user.as_json
        response[:name] = current_user.family_detail&.family_name
        response[:images] = current_user.family_images&.first&.photo&.url
        render json: response
    else
        response = current_user.as_json
        response[:name] = current_user.caregiver_detail&.caregiver_name
        response[:images] = current_user.caregiver_images&.first&.photo&.url
        render json: response
    end
  end

  def create
    @chat = Stay::Chat.between(params[:sender_id], params[:receiver_id]).first_or_create!(chat_params)
    render json: @chat
  end

  def user_conversation
    sender_chat = Stay::Chat.where(sender_id: current_user.id)
    recipient_chat = Stay::Chat.where(receiver_id: current_user.id)

    # Merge sender and recipient conversations
    @chat = sender_chat.or(recipient_chat)

    if @chat.present?
        users_with_chats = @chat.map do |chat|
        other_user_id = chat.sender_id == current_user.id ? chat.receiver_id : chat.sender_id
        other_user = Stay::User.find(other_user_id)
        last_message = chat.messages&.last
        unread_count = chat.messages&.where.not(user_id: current_user.id).where(read: false).count
        {
            id: other_user.id,
            email: other_user.email,
            chat_id: chat.id,
            last_message: last_message&.body,
            last_message_created_at: last_message&.created_at,
            unread_count: unread_count,
            other_user_detail: other_user&.get_detail,
            matched_date: (Match.find_by("(sender_id = :current_user_id AND receiver_id = :other_user_id) OR (sender_id = :other_user_id AND receiver_id = :current_user_id)", current_user_id: current_user.id, other_user_id: other_user.id).created_at rescue nil)
        }
        end
        render json: users_with_chat
    else
        render json: []
    end
  end

  def chat_messages
    @chat = Stay::Chat.find(params[:conversation_id])

    if @chat.present?
                @messages = @chat.messages.map do |message|
        position = message.user_id == current_user.id ? "sender" : "reciever"
        message.attributes.merge(position: position)
        end
                render json: @messages
    else
        render json: { error: "Conversation not found" }, status: :not_found
    end
  end

  def update_conversation_status
    @chat = Stay::Chat.find(params[:id])
    @chat.messages&.where.not(user_id: current_user.id).where(read: false).update_all(read: true) if @chat
    render json: true
  end

  private

  def chat_params
    params.require(:chat).permit(:sender_id, :receiver_id, :property_id)
  end
end
