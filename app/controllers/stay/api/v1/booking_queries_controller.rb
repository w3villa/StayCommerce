class Stay::Api::V1::BookingQueriesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!
  before_action :set_property, except: [:index, :show]
  before_action :booking_availability, only: [:create, :update]
  before_action :set_query, only: [:update, :show]

  def index
    begin
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
      
      cumulative_per_page = page * per_page
      query = current_devise_api_user.booking_queries.where.not(state: "accepted")
      @booking_queries = query.order(created_at: :asc).limit(cumulative_per_page)
    
      total_count = query.count
      total_pages = (total_count.to_f / per_page).ceil
    if @booking_queries.empty?
      return render json: { success: false, error: "Query not found" }, status: :not_found
    end
    render json: {
      success: true,
      booking_queries: ActiveModelSerializers::SerializableResource.new(@booking_queries, each_serializer: BookingQuerySerializer),
      meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { success: false, error: "Query not found", message: e.message }, status: :not_found
  rescue ArgumentError => e
    render json: { success: false, error: "Invalid pagination parameters", message: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { success: false, error: "Internal server error", message: e.message }, status: :internal_server_error
  end
  end
  
  def create
    ActiveRecord::Base.transaction do
      if current_devise_api_user == @property.user
        return render json:{error: "yopu can not query for your own property", success: false}, status: :unprocessable_entity
      end
      chat = create_chat(current_devise_api_user, @property)
      if chat.persisted?
        booking_query = chat.build_booking_query(booking_query_params.merge(property: @property, user: current_devise_api_user))
        if booking_query.save
          Stay::Chat::QueryMessagingService.new(booking_query, current_devise_api_user).perform
          render json: { success: true, booking_query: BookingQuerySerializer.new(booking_query) }, status: :created
        else
          raise ActiveRecord::Rollback
        end
      else
        raise ActiveRecord::Rollback, "Failed to create chat"
      end
    end

  rescue ActiveRecord::Rollback => e
    render json: { success: false, errors: e.message || booking_query.errors.full_messages }, status: :unprocessable_entity
  end

  def show
    last_five = @booking_query.chat&.messages.order(created_at: :desc).limit(5)
    render json: {
      success: true,
      booking_query: BookingQuerySerializer.new(@booking_query),
      booking: @booking_query.booking ? BookingSerializer.new(@booking_query.booking) : nil,
      messages: ActiveModelSerializers::SerializableResource.new(last_five, each_serializer: MessageSerializer)
    }, status: :ok
  end
  

  def update
    if %w[request_change booking_invitation accepted rejected].include?(booking_query_params[:state])
      @booking_query.update(state: booking_query_params[:state].to_sym)
      Stay::Chat::QueryMessagingService.new(@booking_query, current_devise_api_user).perform
    end
  
    unless @booking_query.update(booking_query_params)
      return render json: { success: false, errors: @booking_query.errors.full_messages }, status: :unprocessable_entity
    end
  
    last_five = @booking_query.chat&.messages.order(created_at: :desc).limit(5)

    if @booking_query.accepted?
      if @booking_query.booking.present?
        render json: { success: false, message: "Booking already created for this query" }, status: :unprocessable_entity
      else
        result = Stay::Bookings::CreateBookingService.new(@booking_query).perform
        if result[:success]
          render json: { 
            message: "Booking created successfully",
            success: true,
            booking_query: BookingQuerySerializer.new(@booking_query),
            booking: @booking_query.booking ? BookingSerializer.new(@booking_query.booking) : nil,
            messages: ActiveModelSerializers::SerializableResource.new(last_five, each_serializer: MessageSerializer)
          }, status: :ok
        else
          render json: { success: false, errors: result[:errors] }, status: :unprocessable_entity
        end
      end
    else
      render json: { 
        success: true,
        booking_query: BookingQuerySerializer.new(@booking_query),
        booking: @booking_query.booking ? BookingSerializer.new(@booking_query.booking) : nil,
        messages: ActiveModelSerializers::SerializableResource.new(last_five, each_serializer: MessageSerializer)
      }, status: :ok, status: :ok
    end
  end

  private

  def set_property
    @property = Stay::Property.find_by(id: params[:property_id])
    render json: { success: false, error: "Property not found" }, status: :not_found unless @property
  end

  def create_chat(user, property)
    host = property.user
    Stay::Chat.between(current_devise_api_user.id, host.id).create!(sender: user, receiver: host, property: property)
  end

  def set_query
    begin
      @booking_query = Stay::BookingQuery.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, error: "Query not found" }, status: :not_found
    end
  end

  def booking_query_params
    params.require(:booking_query).permit(:chat_id, :user_id, :check_in_date, :check_out_date, :query, :booking_id, :state, :guest_count, :property_id, query_for: {})
  end

  def booking_availability
    if @property.user.nil?
      return render json: { success: false, message: "Property Host not active." }, status: :not_found
    end

    if @property&.user == current_devise_api_user
      return render json: { success: false, message: "You can not create booking for your own Property" }, status: :unprocessable_entity
    end
  end

  def existing_query
    
  end
end
