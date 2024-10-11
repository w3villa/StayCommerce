module Stay
  class PropertyCategory < ApplicationRecord
    has_many :properties, class_name: "Stay::Property"
    belongs_to :property_type, class_name: "Stay::PropertyType"
    belongs_to :room_type, class_name: "Stay::RoomType"
  end
end
