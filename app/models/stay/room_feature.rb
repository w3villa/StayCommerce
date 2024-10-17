module Stay
  class RoomFeature < ApplicationRecord
    belongs_to :room, class_name: "Stay::Room"
    belongs_to :feature, class_name: "Stay::Feature"
  end
end
