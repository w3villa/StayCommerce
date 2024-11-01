module Stay
  class Invoice < ApplicationRecord
    belongs_to :booking
    has_many :expenses, dependent: :destroy
    has_many :discounts, dependent: :destroy
    after_commit :calculate_totals, on: [:create, :update]

    accepts_nested_attributes_for :expenses, allow_destroy: true
    accepts_nested_attributes_for :discounts, allow_destroy: true

    private

    def calculate_totals
      subtotal = expenses.any? ? expenses.pluck(:amount).sum : 0
      discount_amount = discounts.any? ? discounts.pluck(:amount).sum : 0
      total = subtotal - discount_amount

      if subtotal != self.subtotal || discount_amount != self.discount_amount || total != self.total
        update_columns(subtotal: subtotal, discount_amount: discount_amount, total: total)
      end
    end
  end
end
