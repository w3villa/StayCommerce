module Stay
  class Invoice < ApplicationRecord
    belongs_to :booking
    has_many :expenses, dependent: :destroy
    has_many :discounts, dependent: :destroy
    after_commit :calculate_totals
    
    accepts_nested_attributes_for :expenses, allow_destroy: true
    accepts_nested_attributes_for :discounts, allow_destroy: true

    private

    def calculate_totals
      subtotal = expenses.pluck(:amount).sum
      discount_amount = discounts.pluck(:amount).sum
      total = subtotal + discount_amount
    end
  end
end
