module Stay
  class PaymentMethod < ApplicationRecord
    has_many :payments, class_name: 'Stay::Payment', dependent: :destroy
  end
end
