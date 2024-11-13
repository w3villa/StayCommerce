module Stay
  class PropertyType < ApplicationRecord
    validates :name, presence: true
  end
end
