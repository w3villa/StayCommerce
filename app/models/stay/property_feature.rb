module Stay
  class PropertyFeature < ApplicationRecord
    belongs_to :property, class_name: "Stay::Property"
    belongs_to :feature, class_name: "Stay::Feature"
  end
end
