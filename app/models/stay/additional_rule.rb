module Stay
  class AdditionalRule < ApplicationRecord
    belongs_to :property, class_name: "Stay::Property"
  end
end
