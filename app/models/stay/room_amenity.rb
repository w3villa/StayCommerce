module Stay
  class RoomAmenity < ApplicationRecord
    belongs_to :room, foreign_key: 'stay_room_id', class_name: 'Stay::Room'
    belongs_to :amenity, foreign_key: 'stay_amenity_id', class_name: 'Stay::Amenity'
  end
end
