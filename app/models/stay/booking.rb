module Stay
  class Booking < ApplicationRecord
    belongs_to :user, class_name: 'Stay::User'
    belongs_to :room, class_name: 'Stay::Room'
  end
end
