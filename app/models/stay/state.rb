module Stay
  class State < ApplicationRecord
    belongs_to :country, class_name: "Stay::Country"
    has_many :cities, class_name: "Stay::City"
    has_many :addresses, dependent: :destroy
  end
end
