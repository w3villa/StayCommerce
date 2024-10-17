module Stay
  class Tax < ApplicationRecord
    has_many :property_taxes, class_name: "Stay::PropertyTax"
    has_many :properties, through: :property_taxes, class_name: "Stay::Property"

    validates :name, presence: true
  end
end
