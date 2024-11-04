module Stay
  module Bookings
    class CreateBookingService
      def initialize(booking_query)
        @booking_query = booking_query
      end

      def perform
        user = @booking_query.user
        property = @booking_query.property
        room_numbers = @booking_query.query_for["room_number"]
        line_items_attributes = build_line_items(room_numbers)
        @booking = Stay::Booking.new(
          user: user,
          property: property,
          check_in_date: @booking_query.check_in_date,
          check_out_date: @booking_query.check_out_date,
          number_of_guests: @booking_query.guest_count, 
          line_items_attributes: line_items_attributes,
        )
        @booking.chat = @booking_query.chat
        if @booking.save
          @booking_query.update(booking: @booking)
          { success: true, booking: @booking }
        else
          { success: false, errors: @booking.errors.full_messages }
        end
      end

      private

      def build_line_items(room_numbers)
        room_numbers.map do |room_number|
          {
            room_id: find_room_id(room_number),
            price: 100,
            quantity: 1,
            property_id: @booking_query.property.id
          }
        end
      end

      def find_room_id(room_number)
        Stay::Room.find_by(id: room_number)&.id
      end
    end
  end
end
