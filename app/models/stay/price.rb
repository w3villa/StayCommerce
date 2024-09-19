module Stay
  class Price < ApplicationRecord
    # MAXIMUM_AMOUNT = BigDecimal('99_999_999.99')

    belongs_to :rooms, class_name: Stay::Room
  end
end
