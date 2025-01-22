module Stay
  module Bookings
    class CreateBookingService
      def initialize(booking_query)
        @booking_query = booking_query
      end

      def perform
        user = @booking_query.user
        property = @booking_query.property

        room_numbers = @booking_query&.query_for.present? ? @booking_query.query_for["room_number"] : @booking_query.property.rooms.pluck(:id)
        active_rooms = filter_active_rooms(room_numbers)

        if active_rooms.empty?
          return { success: false, errors:  "No active rooms are available to book."  }
        end

        line_items_attributes = build_line_items(active_rooms)

        @booking = Stay::Booking.new(
          user: user,
          property: property,
          check_in_date: @booking_query.check_in_date,
          check_out_date: @booking_query.check_out_date,
          number_of_guests: @booking_query.guest_count,
          line_items_attributes: line_items_attributes
        )

        @booking.chat = @booking_query.chat
        if @booking.save
          @booking.calculate_totals
          @booking_query.update(booking: @booking)
          { success: true, booking: @booking }
        else
          { success: false, errors: @booking.errors.full_messages }
        end
      end

      private

      def build_line_items(room_numbers)
        room_numbers.map do |room_number|
          room = find_room(room_number)
          next if room.nil? || room.status == "inactive"
          {
            room_id: room.id,
            price: room.price_per_month || 0,
            quantity: 1,
            property_id: @booking_query.property.id
          }
        end.compact
      end

      def find_room(room_number)
        Stay::Room.find_by(id: room_number)
      end

      def filter_active_rooms(room_numbers)
        room_numbers.select do |room_number|
          room = find_room(room_number)
          room.present? && room.status != "inactive"
        end
      end
    end
  end
end
