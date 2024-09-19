module Stay
  class RoomType < ApplicationRecord
    has_many :rooms, class_name: 'Stay::Room'
  end
end
