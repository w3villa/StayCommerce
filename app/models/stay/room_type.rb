module Stay
  class RoomType < ApplicationRecord
    has_many :rooms, class_name: "Stay::Room", dependent: :destroy

    validates :name,  presence: true, uniqueness: { case_sensitive: false }, format: { without: /\s/, message: "must contain no spaces" }
  end
end
