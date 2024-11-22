module Stay
  class PropertyCategory < ApplicationRecord
    has_many :properties, class_name: "Stay::Property"
    validates :name, presence: true, uniqueness: true
  end
end
