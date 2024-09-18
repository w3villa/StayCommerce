module Stay
  class Property < ApplicationRecord
    has_many :rooms, class_name: 'Stay::Room', dependent: :destroy
    has_many :chats, class_name: 'Stay::Chat', dependent: :destroy

    belongs_to :user, class_name: 'Stay::User', optional: true
    belongs_to :address, class_name: 'Stay::Address', optional: true
    has_many_attached :images

    has_many :prices, through: :rooms
    has_many :bookings

    def has_rooms?
      rooms.any?
    end

    def deleted?
      !!deleted_at
    end
  end
end
