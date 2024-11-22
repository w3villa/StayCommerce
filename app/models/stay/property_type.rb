module Stay
  class PropertyType < ApplicationRecord
    validates :name, presence: true, uniqueness: true
  end
end
