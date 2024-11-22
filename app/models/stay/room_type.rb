module Stay
  class RoomType < ApplicationRecord
    has_many :rooms, class_name: "Stay::Room"

    validates :name, presence: true, uniqueness: true
  end
end
