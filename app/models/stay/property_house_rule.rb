module Stay
  class PropertyHouseRule < ApplicationRecord
    belongs_to :property
    belongs_to :house_rule
  end
end
