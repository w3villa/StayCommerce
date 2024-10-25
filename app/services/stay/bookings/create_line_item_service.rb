module Stay
  module Bookings
    class CreateLineItemService
      def initialize(booking, room)
        @booking = booking
        @room = room
      end

      def perform
        raise "Room not provided" unless @room
        @room.line_items.create!(booking: @booking, price: @room.price_per_night, quantity:1)
      end
    end
  end
end
