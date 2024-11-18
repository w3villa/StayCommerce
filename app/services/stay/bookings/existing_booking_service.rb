module Stay
  module Bookings
    class ExistingBookingService
      def initialize(booking, params)
        @booking = booking
        @params = params
      end

      def perform
        user = @booking.user
        property = @booking.property
        unless property.shared_property
          room_numbers = @booking.property.rooms.pluck(:id)
        else
          room_numbers = @params[:line_items_attributes].map { |r| r["room_id"] } if @params[:line_items_attributes].any?
        end
        if room_numbers.any?
          line_items_attributes = build_line_items(room_numbers)
          @booking.line_items_attributes = line_items_attributes
        end

        if @booking.update(
            check_in_date: @params[:check_in_date],
            check_out_date: @params[:check_out_date],
            number_of_guests: @params[:number_of_guests]
          )
          @booking.calculate_totals
          { success: true, booking: @booking }

        else
          { success: false, errors: @booking.errors.full_messages }
        end
      end

      private

      def build_line_items(room_numbers)
        room_numbers.map do |room_number|
          room = Stay::Room.find_by(id: room_number)
          {
            room_id: room.id,
            price: room.price,
            quantity: 1,
            property_id: room.property.id
          }
        end
      end
    end
  end
end
