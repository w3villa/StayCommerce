module Stay
    class CreditCard < ApplicationRecord
        belongs_to :user, class_name: 'Spree::User'
        belongs_to :payment_method, class_name: 'Spree::PaymentMethod'
        has_many :payments, as: :source
    
        validates :month,:year, :cc_type, presence: true
    end
end