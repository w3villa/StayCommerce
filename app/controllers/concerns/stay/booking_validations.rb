module Stay
  module BookingValidations
    extend ActiveSupport::Concern

    included do
      before_action :validate_booking_params, only: :create
    end

    private

    def validate_booking_params
      property = Stay::Property.friendly.find_by(slug: booking_params[:property_id])

      return render_error("Property not found.", :not_found) unless property

      return render_error("Property Host not active.", :not_found) unless property.user

      return render_error("You cannot create a booking for your own property.", :unprocessable_entity) if property.user == current_devise_api_user

      return render_error("Hosts cannot create bookings for properties.", :unprocessable_entity) if current_devise_api_user.stay_host?

      if booking_params[:check_in_date].nil? || booking_params[:check_out_date].nil?
        return render_error("Please select both check-in and check-out dates.", :unprocessable_entity)
      end

      return render_error("Please select the guest count.", :unprocessable_entity) if booking_params[:number_of_guests].nil?

      if property.shared_property && booking_params[:line_items_attributes].nil?
        return render_error("Please select a room for the shared property.", :unprocessable_entity)
      end

      validate_shared_property_room(property) if property.shared_property
      validate_guest_limit(property)
      validate_property_availability(property)
    end

    def validate_shared_property_room(property)
      line_item = booking_params[:line_items_attributes][0]
      return unless line_item

      room_id = line_item[:room_id]
      check_in_date = booking_params[:check_in_date].to_date
      check_out_date = booking_params[:check_out_date].to_date
      room = Stay::Room.find_by(id: room_id)

      if room.nil?
        render_error("Room not found.", :not_found)
      elsif room.property_id != property.id
        render_error("Room not found in the property.", :not_found)
      elsif room.status == "inactive"
        render_error("Room is inactive.", :unprocessable_entity)
      elsif !property.allow_extra_guest && booking_params[:number_of_guests] > room.max_guests
        render_error("No extra guests allowed. Maximum guest limit for this room is #{room.max_guests || 1}.", :unprocessable_entity)
      elsif check_in_date < room.booking_start.to_date
        render_error("Room not available on your check-in date.", :unprocessable_entity)
      elsif check_out_date > room.booking_end.to_date
        render_error("Room not available on your check-out date.", :unprocessable_entity)
      end
    end

    def validate_guest_limit(property)
      if !property.shared_property && !property.allow_extra_guest && booking_params[:number_of_guests] > property.guest_number
        render_error("No extra guests allowed. Maximum guest limit for this property is #{property.guest_number || 1}.", :unprocessable_entity)
      end
    end

    def validate_property_availability(property)
      check_in_date = booking_params[:check_in_date].to_date
      check_out_date = booking_params[:check_out_date].to_date

      if property.unlimited_availability
        if check_in_date < property.availability_start.to_date
          render_error("Property not available on your check-in date.", :unprocessable_entity)
        elsif check_in_date > check_out_date
          render_error("Check-out date cannot be earlier than check-in date.", :unprocessable_entity)
        end
      else
        if check_in_date < property.availability_start.to_date
          render_error("Property not available on your check-in date.", :unprocessable_entity)
        elsif check_out_date > property.availability_end.to_date
          render_error("Property not available on your check-out date.", :unprocessable_entity)
        end
      end
    end
  end
end
