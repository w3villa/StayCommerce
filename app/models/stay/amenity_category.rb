module Stay
  class AmenityCategory < ApplicationRecord
    has_many :amenities, class_name: "Stay::Amenity"
    validates :name, presence: true
  end
end
