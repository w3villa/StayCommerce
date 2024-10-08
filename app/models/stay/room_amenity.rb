module Stay
  class RoomAmenity < ApplicationRecord
    belongs_to :room, class_name: "Stay:Room"
    belongs_to :amenity, class_name: "Stay:Amenity"
  end
end
