module Stay
  class Country < ApplicationRecord
    has_many :addresses
    has_many :states, class_name: 'Stay::State', dependent: :destroy
  end
end
