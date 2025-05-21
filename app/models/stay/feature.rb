module Stay
  class Feature < ApplicationRecord
    has_many :property_features, class_name: "Stay::PropertyFeature"
    has_many :properties, through: :property_features, class_name: "Stay::Property"
    has_many :room_features, class_name: "Stay::RoomFeature"
    has_many :rooms, through: :room_features, class_name: "Stay::Room"
    has_one_attached :image

    enum :feature_type, { property: 0, room: 1 }
  end
end
