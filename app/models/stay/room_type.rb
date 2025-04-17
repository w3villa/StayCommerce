module Stay
  class RoomType < ApplicationRecord
    has_many :rooms, class_name: "Stay::Room", dependent: :destroy
    has_rich_text :description

    validates :name,  presence: true, uniqueness: { case_sensitive: false },
    format: { without: /_/, message: "must not contain underscores" }
  end
end
