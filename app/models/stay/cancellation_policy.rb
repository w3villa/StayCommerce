module Stay
  class CancellationPolicy < ApplicationRecord
    has_many :stay_properties, class_name: "Stay::Property"
  end
end
