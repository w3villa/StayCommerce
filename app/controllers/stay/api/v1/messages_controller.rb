class Stay::Api::V1::MessagesController < Stay::BaseApiController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :authenticate_devise_api_token!
  before_action :set_chat
  before_action :set_message, only: [ :mark_as_read ]

  def index
    begin
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
      cumulative_limit = page * per_page

      @chat.messages
           .where("sender_id = :user_id OR receiver_id = :user_id", user_id: current_devise_api_user.id)
           .where(read_at: nil)
           .update_all(read_at: DateTime.now)

      total_count = @chat.messages.count
      total_pages = (total_count.to_f / per_page).ceil

      messages = @chat.messages
                      .order(created_at: :desc)
                      .limit(cumulative_limit)

      grouped_messages = messages
                           .select("DATE(created_at) as message_date, stay_messages.*")
                           .group_by { |message| message.created_at.to_date }

      grouped_messages_json = grouped_messages.transform_keys(&:to_s).map do |date, msgs|
        {
          date: formatted_date(date.to_date),
          messages: ActiveModelSerializers::SerializableResource.new(msgs, each_serializer: MessageSerializer)
        }
      end

      serialized_chat = ActiveModelSerializers::SerializableResource.new(@chat, serializer: ChatSerializer, scope: { current_user: current_devise_api_user })

      render json: {
        data: "Messages Found",
        chat: serialized_chat,
        message: grouped_messages_json,
        success: true,
        meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
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
      message.chat = @chat
      message.event_for= Stay::Message.event_fors["both"]

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
          chat: ActiveModelSerializers::SerializableResource.new(@chat, serializer: ChatSerializer, scope: { current_user: current_devise_api_user }),
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

  def mark_as_read
    if @message.receiver_id == current_devise_api_user.id
      @chat.messages.where(receiver_id: current_devise_api_user.id).update_all(read_at: DateTime.now)
      render json: { message: "Message marked as read", success: true }, status: :ok
    elsif @message.sender_id == current_devise_api_user.id
      @chat.messages.where(sender_id: current_devise_api_user.id).update_all(read_at: DateTime.now)
      render json: { message: "Message marked as read", success: true }, status: :ok
    else
      render json: { error: "You are not authorized to read this message" }, status: :unauthorized
    end
  end

  private

  def set_message
    begin
      @message = Stay::Message.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, error: "message not found" }, status: :not_found
    end
  end

  def set_chat
    begin
      @chat = Stay::Chat.find(params[:chat_id])
      unless @chat.sender_id == current_devise_api_user.id || @chat.receiver_id == current_devise_api_user.id
        render json: { error: "not authorized to view this chat", success: false }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Chat not found: #{e.message}", success: false }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message, success: false }, status: :internal_server_error
    end
  end

  def formatted_date(date)
    if date.to_date == Date.today
      "Today"
    elsif date.to_date == Date.yesterday
      "Yesterday"
    else
      date.to_date.strftime("%B %d, %Y")
    end
  end

  def message_params
    params.require(:message).permit(:body, :sender_id, :receiver_id, attachments: [])
  end
end
