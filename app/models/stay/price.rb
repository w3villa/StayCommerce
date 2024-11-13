module Stay
  class Price < ApplicationRecord
    MAXIMUM_AMOUNT = BigDecimal('99_999_999.99')

    belongs_to :room, class_name: 'Stay::Room'
    before_validation :ensure_currency
    validates :amount, allow_nil: true, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: MAXIMUM_AMOUNT
    }
    
    private

    def ensure_currency
      self.currency ||= Stay::Store.default.default_currency
    end
  end
end
