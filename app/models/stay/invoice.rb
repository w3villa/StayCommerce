module Stay
  class Invoice < ApplicationRecord
    belongs_to :booking
    has_many :expenses, dependent: :destroy
    has_many :discounts, dependent: :destroy
    
    accepts_nested_attributes_for :expenses, allow_destroy: true
    accepts_nested_attributes_for :discounts, allow_destroy: true
  end
end
