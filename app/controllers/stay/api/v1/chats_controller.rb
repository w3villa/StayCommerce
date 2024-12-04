class Stay::Api::V1::ChatsController < ApplicationController
  before_action :authenticate_devise_api_token!
  before_action :check_admin_access, only: :index

  def index
    begin
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
      cumulative_per_page = page * per_page

      chats = Stay::Chat.joins(:messages, :property).where(stay_properties: { user: current_devise_api_user })
      chats = params[:unread].present? ? chats.get_unread_messages_chat : chats.get_all_messages
      chats = chats.order_by_latest_messages
      return render json: { error: "No chats found", success: false }, status: :unprocessable_entity if chats.empty?

      total_count = chats.length
      chats = chats.limit(cumulative_per_page)
      total_pages = (total_count.to_f / per_page).ceil

      data = {
        message: "Chats Found",
        chats: ActiveModelSerializers::SerializableResource.new(chats, each_serializer: ChatSerializer, scope: { current_user: current_devise_api_user }),
        success: true,
        meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
      }
      render json: { data: data }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, error: "Properties not found", message: e.message }, status: :not_found
    rescue ArgumentError => e
      render json: { success: false, error: "Invalid pagination parameters", message: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { success: false, error: "Internal server error", message: e.message }, status: :internal_server_error
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
    begin
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10

      cumulative_per_page = page * per_page
      @chats = Stay::Chat.for_user(current_devise_api_user)

      @chats = params[:unread].present? ? @chats.get_unread_messages_chat : @chats.get_all_messages
      @chats = @chats.order_by_latest_messages
      return render json: { error: "No chats found", success: false }, status: :unprocessable_entity if @chats.empty?

      total_count = @chats.length
      @chats = @chats.limit(cumulative_per_page)
      total_pages = (total_count.to_f / per_page).ceil

      data = {
        message: @chats.any? ? "Chats Found" : "No Chat Found",
        chats: @chats.any? ? ActiveModelSerializers::SerializableResource.new(@chats, each_serializer: ChatSerializer, scope: { current_user: current_devise_api_user }) : [],
        success: @chats.any? ? true : false,
        meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
      }
      render json: { data: data }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, error: "Chat not found", message: e.message }, status: :not_found
    rescue ArgumentError => e
      render json: { success: false, error: "Invalid pagination parameters", message: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { success: false, error: "Internal server error", message: e.message }, status: :internal_server_error
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

  def check_admin_access
    render json: { error: "not authorize to see this chat", success: false }, status: :unprocessable_entity unless current_devise_api_user.stay_host?
  end

  def chat_params
    params.require(:chat).permit(:sender_id, :receiver_id, :property_id, :booking_id, :chat_event, :event_message)
  end
end
