
class Stay::Api::V1::BookingsController < Stay::BaseApiController
    before_action :set_room
    before_action :set_booking , only: [:show, :update]
    
    def create 
        @booking = Stay::Booking.new(booking_params.merge(user: current_devise_api_user, status: 'pending'))

        if @booking.save
            @room.line_items.create(booking: @booking)
            render json: { booking: @booking }, status: :created
        else
            render json: { error: @booking.errors.full_messages }, status: :unprocessable_entity
        end
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
        params.require(:booking).permit(:check_in_date, :check_out_date, :number_of_guests, :total_amount)
    end

    def set_room
        @room = Stay::Room.find(params[:room_id])
    end

    def set_booking
        @booking = @room.bookings.find(params[:id])
    end
end
