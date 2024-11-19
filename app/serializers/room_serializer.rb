class RoomSerializer < ActiveModel::Serializer
  attributes :id, :max_guests, :price_per_month, :status,
             :booking_start, :booking_end, :description,
            :size, :bed_type, :room_type, :amenities, :features

  def bed_type
    return nil unless object.bed_type.present?
    BedTypeSerializer.new(object.bed_type)
  end

  def room_type
    RoomTypeSerializer.new(object.room_type)
  end

  def amenities
    ActiveModelSerializers::SerializableResource.new(object.amenities.room.uniq, each_serializer: AmenitySerializer)
  end

  def features
    ActiveModelSerializers::SerializableResource.new(object.features.room.uniq, each_serializer: PropertyFeatureSerializer)
  end

  def room_images
    object.room_images.attached? ? object.images_urls : []
  end
end
