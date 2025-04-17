class RoomSerializer < ActiveModel::Serializer
  attributes :id, :max_guests, :price_per_month, :status, :booked_dates,
             :booking_start, :booking_end, :description,
             :size, :bed_type, :room_type, :amenities, :features, :room_images

  def bed_type
    object.bed_type && BedTypeSerializer.new(object.bed_type)
  end

  def room_type
    object.room_type && RoomTypeSerializer.new(object.room_type)
  end

  def amenities
    ActiveModelSerializers::SerializableResource.new(object.amenities.distinct, each_serializer: AmenitySerializer)
  end

  def features
    ActiveModelSerializers::SerializableResource.new(object.features.distinct, each_serializer: FeatureSerializer)
  end

  def room_images
    object.room_images.map(&:url).compact
  end

  def booked_dates
    return [] unless object.property&.shared_property

    bookings = Stay::Booking.joins(line_items: :property)
                            .where(line_items: { room_id: object.id })
    bookings.exists? ? bookings.pluck(:check_in_date, :check_out_date).uniq : []
  rescue StandardError => e
    Rails.logger.error("Error fetching bookings for room #{object.id}: #{e.message}")
    []
  end
end
