module Stay
  class Review < ApplicationRecord
     belongs_to :booking
     has_one :user, through: :booking
     has_many :rooms, through: :booking
     has_one :property, through: :rooms
     validates :rating, presence: true, inclusion: { in: 1..5 }
     validates :comment, presence: true

     validate :booking_completed

     private

    def booking_completed
      errors.add(:booking, "must be completed to leave a review") unless booking.completed?
    end
  end
end
