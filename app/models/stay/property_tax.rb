module Stay
  class PropertyTax < ApplicationRecord
    belongs_to :tax, class_name: 'Stay::Tax', touch: true
    belongs_to :property, class_name: 'Stay::Property', touch: true
  end
end
