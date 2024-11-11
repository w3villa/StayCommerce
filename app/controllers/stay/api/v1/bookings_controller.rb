class Stay::Api::V1::BookingsController < Stay::BaseApiController
  before_action :set_booking , only: [:show, :update, :delete_line_item, :booking_chat]
  before_action :booking_availability, only: [:create]
  before_action :authenticate_devise_api_token!

  def index
    begin
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
      
      cumulative_per_page = page * per_page
      
      @bookings = current_devise_api_user.bookings&.complete
                  .order(created_at: :desc)
                  .limit(cumulative_per_page)
      
      total_count = current_devise_api_user.bookings&.complete.count
      total_pages = (total_count.to_f / per_page).ceil
  
      if @bookings.empty?
        return render json: { data: "No bookings found", bookings: [], success: false }, status: :ok
      end
      
      render json: {
        data: "Bookings Found",
        bookings: ActiveModelSerializers::SerializableResource.new(@bookings, each_serializer: BookingSerializer),
        success: true,
        meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
      }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, error: "Bookings not found", message: e.message }, status: :not_found
    rescue ArgumentError => e
      render json: { success: false, error: "Invalid pagination parameters", message: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { success: false, error: "Internal server error", message: e.message }, status: :internal_server_error
    end
  end
  
  def create 
    @booking = Stay::Booking.new(booking_params.merge(user: current_devise_api_user))
    if @booking.save
        Stay::Chat::ChatMessagingService.new(@booking).send_initial_messages
        @booking.calculate_totals
        render json: {  data: BookingSerializer.new(@booking), success: true}, status: :created
    else
        render json: { error: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def my_reservation
    begin
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
      
      cumulative_per_page = page * per_page
      @bookings = current_devise_api_user.bookings.incomplete
                   .order(created_at: :desc)
                   .limit(cumulative_per_page)
      
      total_count = current_devise_api_user.bookings.incomplete&.count
      total_pages = (total_count.to_f / per_page).ceil
  
      if @bookings.empty?
        return render json: { data: "No bookings found", bookings: [], success: false }, status: :ok
      end
      
      render json: {
        data: "Bookings Found",
        bookings: ActiveModelSerializers::SerializableResource.new(@bookings, each_serializer: BookingSerializer),
        success: true,
        meta: {
          total_pages: total_pages,
          current_page: page,
          next_page: page < total_pages ? page + 1 : nil,
          prev_page: page > 1 ? page - 1 : nil,
          total_count: total_count
        }
      }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { success: false, error: "Bookings not found", message: e.message }, status: :not_found
    rescue ArgumentError => e
      render json: { success: false, error: "Invalid pagination parameters", message: e.message }, status: :bad_request
    rescue StandardError => e
      render json: { success: false, error: "Internal server error", message: e.message }, status: :internal_server_error
    end
  end


  def booking_chat
    @chat = @booking.chat
    if @chat.present? && @chat.messages.any?
      @messages = @chat.messages.page(params[:page]).per(params[:per_page] || 10 )
      render json: {    
        booking: BookingSerializer.new(@booking),
        chat: ChatSerializer.new(@booking.chat, scope: { current_user: current_devise_api_user }),
        messages: ActiveModelSerializers::SerializableResource.new(@messages, each_serializer: MessageSerializer),
        success: true,
        meta: {
          total_pages: @messages.total_pages,
          current_page: @messages.current_page,
          next_page: @messages.next_page,
          prev_page: @messages.prev_page,
          total_count: @messages.total_count
        }
      }, status: :ok
    else
      render json: { error: "no chat found", success: false}, status: :unprocessable_entity
    end
  end

  def show
      render json: { booking: BookingSerializer.new(@booking), booking_query: @booking&.booking_query.present? ? BookingQuerySerializer.new(@booking&.booking_query) : nil,  success: true}, status: :ok
  end

  def update
    if @booking.payment_state == 'failed' && params[:booking][:status] == 'confirmed'
      return render json: { error: "Booking cannot be confirmed due to failed payment." }, status: :unprocessable_entity
    end

    if @booking.update(booking_params)
      @booking.update_columns(canceler_id: current_devise_api_user.id,canceled_at: Time.current) if @booking.canceled?
      if @booking.saved_change_to_status?
        Stay::Chat::ChatMessagingService.new(@booking).send_initial_messages
      end
      @booking.calculate_totals
      render json: { data: BookingSerializer.new(@booking), success: true }, status: :ok
    else
      render json: { error: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete_line_item
    room = @booking.line_items.find_by(room_id: params[:room_id])
    if room&.destroy
      unless @booking.line_items.exists?
        @booking.destroy
        return render json: { message: "Booking deleted successfully", success: true }, status: :ok
      end
      render json: { message: "Room deleted successfully", data: BookingSerializer.new(@booking), success: true }, status: :ok
    else
      render json: { error: room ? room.errors.full_messages : "Room not found" }, status: :unprocessable_entity
    end
  end

  private
  def booking_params
    params.require(:booking).permit(
      :check_in_date, :check_out_date, :number_of_guests, :total_amount, :property_id, :status, :payment_intent_id,
      line_items_attributes: [:id, :room_id, :price, :quantity, :property_id],
      payments_attributes: [:id, :payment_method_id, :amount, :state, :transaction_id, :intent_client_key],
      invoice_attributes: [
        :id, :total, :invoice_period, :invoice_type, :billing_type, :status, :_destroy,
        discounts_attributes: [:id, :amount, :description,  :_destroy],
        expenses_attributes: [:id, :amount, :category,  :_destroy]
      ]
    )
  end

  def set_room
    @room = Stay::Room.find(params[:room_id])
  end

  def booking_availability
    property = Stay::Property.find_by(id: params[:booking][:property_id])
  
    if property.nil?
      return render json: { success: false, message: "Property not found." }, status: :not_found
    end

    unless property.user
      return render json: { success: false, message: "Property Host not active." }, status: :not_found
    end

    if property.user == current_devise_api_user
      return render json: { success: false, message: "You can not create booking for your own Property" }, status: :unprocessable_entity
    end
  
    check_in_date = params[:booking][:check_in_date].to_date
    check_out_date = params[:booking][:check_out_date].to_date
  
    if check_in_date < property.availability_start.to_date
      return render json: { success: false, message: "Check-in date cannot be earlier than the property's check-in date." }, status: :unprocessable_entity
    elsif check_out_date > property.availability_end.to_date
      return render json: { success: false, message: "Check-out date cannot be greater than the property's check-out date." }, status: :unprocessable_entity
    end
  end
  

  def set_booking
    @booking = Stay::Booking.find_by(id: params[:id])
    return render json:{error: "no booking found", success: false}, status: :unprocessable_entity if  @booking.nil?
  end
end
