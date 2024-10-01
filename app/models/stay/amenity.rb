module Stay
  class Amenity < ApplicationRecord
    has_many :room_amenities, foreign_key: 'stay_amenity_id', class_name: 'Stay::RoomAmenity'
    has_many :rooms, through: :room_amenities, source: :room
  end
end
