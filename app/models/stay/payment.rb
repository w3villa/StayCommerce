module Stay
  class Payment < ApplicationRecord
    belongs_to :booking, class_name: 'Stay::Booking'
    belongs_to :payment_method, class_name: 'Stay::PaymentMethod'
  end
end
