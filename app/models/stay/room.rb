module Stay
  class Room < ApplicationRecord
    belongs_to :property, class_name: 'Stay::Property'
    has_many :bookings, class_name: 'Stay::Booking', dependent: :destroy
  end
end