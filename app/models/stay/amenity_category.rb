module Stay
  class AmenityCategory < ApplicationRecord
    has_many :amenities, class_name: "Stay::Amenity"
  end
end
