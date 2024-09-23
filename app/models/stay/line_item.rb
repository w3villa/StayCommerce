module Stay
  class LineItem < ApplicationRecord
    belongs_to :booking, class_name: 'Stay::Booking'
    belongs_to :room, class_name: 'Stay::Room'
    has_one :property, through: :room
  end
end
