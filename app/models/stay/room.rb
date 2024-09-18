module Stay
  class Room < ApplicationRecord
    belongs_to :property, class_name: 'Stay::Property'
    has_many :bookings, class_name: 'Stay::Booking', dependent: :destroy
    has_many_attached :images

    has_many :prices,
             class_name: 'Stay::Price',
             dependent: :destroy,
             inverse_of: :room
  end
end
