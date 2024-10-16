module Stay
  class PropertyCategory < ApplicationRecord
    has_many :properties, class_name: "Stay::Property"
  end
end
