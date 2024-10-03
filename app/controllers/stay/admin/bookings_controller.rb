module Stay
  module Admin
    class BookingsController < Stay::Admin::BaseController
      before_action :set_booking, only: %i[show edit update destroy]

      def index
        @bookings = current_store.bookings.order(created_at: :desc).page(params[:page])
      end

      def show
      end

      def new
        @booking = current_store.bookings.build
      end

      def create
        @booking = current_store.bookings.build(booking_params)
        if @booking.save
          redirect_to admin_booking_path(@booking), notice: 'Booking was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @booking.update(booking_params)
          redirect_to admin_booking_path(@booking), notice: 'Booking was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @booking.destroy
        redirect_to admin_bookings_url, notice: 'Booking was successfully destroyed.'
      end

      private

      def set_booking
        @booking = current_store.bookings.find_by(id: params[:id])
      end

      def booking_params
        params.require(:booking).permit(:user_id, :check_in_date, :check_out_date, :number_of_guests, :status)
      end
    end
  end
end
