module Stay
  class PropertyAmenity < ApplicationRecord
    belongs_to :property, class_name: "Stay::Property"
    belongs_to :amenity, class_name: "Stay::Amenity"
  end
end
