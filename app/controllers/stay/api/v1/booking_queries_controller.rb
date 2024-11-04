class Stay::Api::V1::BookingQueriesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!
  before_action :set_property
  before_action :set_query, only: [:update, :show]

  def create
    ActiveRecord::Base.transaction do
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
    render json: { success: true, booking_query: BookingQuerySerializer.new(@booking_query) }, status: :created
  end

  def update
    if %w[request_change booking_invitation accepted rejected].include?(booking_query_params[:state])
      @booking_query.update(state: booking_query_params[:state].to_sym)
      Stay::Chat::QueryMessagingService.new(@booking_query, current_devise_api_user).perform
    end
  
    unless @booking_query.update(booking_query_params)
      return render json: { success: false, errors: @booking_query.errors.full_messages }, status: :unprocessable_entity
    end
  
    if @booking_query.accepted?
      if @booking_query.booking.present?
        render json: { success: false, message: "Booking already created for this query" }, status: :unprocessable_entity
      else
        result = Stay::Bookings::CreateBookingService.new(@booking_query).perform
        if result[:success]
          render json: { success: true, booking_query: BookingQuerySerializer.new(@booking_query), message: "Booking created successfully" }, status: :ok
        else
          render json: { success: false, errors: result[:errors] }, status: :unprocessable_entity
        end
      end
    else
      render json: { success: true, booking_query: BookingQuerySerializer.new(@booking_query) }, status: :ok
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
    @booking_query = Stay::BookingQuery.find(params[:id])
  end

  def booking_query_params
    params.require(:booking_query).permit(:chat_id, :user_id, :check_in_date, :check_out_date, :query, :booking_id, :state, :guest_count, :property_id, query_for: {})
  end
end
