module Stay
  class CreditCard < ApplicationRecord
    belongs_to :user, class_name: "Stay::User"
    belongs_to :payment_method, class_name: "Stay::PaymentMethod", optional: :true
  end
end
