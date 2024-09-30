module Stay
  class Amenity < ApplicationRecord
    has_many :room_amenities
    has_many :rooms, through: :room_amenities
  end
end
