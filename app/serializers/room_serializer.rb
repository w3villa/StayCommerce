class RoomSerializer < ActiveModel::Serializer

  attributes :id ,:max_guests,  :price_per_night, :status,
             :booking_start, :booking_end, :description,
            :size, :bed_type

  def bed_type
    BedTypeSerializer.new(object.bed_type)
  end

end