module Stay
  class Amenity < ApplicationRecord
    belongs_to :amenity_category, class_name: "Stay::AmenityCategory"
    has_many :property_amenities, class_name: "Stay::PropertyAmenity"
    has_many :properties, through: :property_amenities, class_name: "Stay::Property"

    has_many :room_amenities, class_name: "Stay::RoomAmenity"
    has_many :rooms, through: :room_amenities, class_name: "Stay::Room"

    validates :name, presence: true
  end
end
