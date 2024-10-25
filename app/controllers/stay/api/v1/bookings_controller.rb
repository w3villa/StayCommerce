
class Stay::Api::V1::BookingsController < Stay::BaseApiController
    before_action :set_booking , only: [:show, :update]
    
    def create
      ActiveRecord::Base.transaction do
        @booking = Stay::Booking.new(booking_params.merge(user: current_devise_api_user, status: 'pending'))
    
        if @booking.save
          if params[:room_id].present?
            begin
              @room = Stay::Room.find_by(id: params[:room_id])
              Stay::Bookings::CreateLineItemService.new(@booking,  @room).perform
              render json: { booking: @booking }, status: :created
            rescue StandardError => e
              raise ActiveRecord::Rollback, "Line item creation failed: #{e.message}" 
            end
          else
            raise ActiveRecord::Rollback, "room_id is required"
          end
        else
          render json: { error: @booking.errors.full_messages }, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
    rescue ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
    
    def show
      render json: { booking: @booking }
    end

    def update
      if @booking.update(booking_params)
          render json: { booking: @booking }, status: :ok
      else
          render json: { error: @booking.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    private
    def booking_params
      params.require(:booking).permit(:check_in_date, :check_out_date, :number_of_guests, :total_amount, :property_id)
    end

    def set_booking
      @booking = @room.bookings.find(params[:id])
    end
end
