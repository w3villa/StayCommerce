module Stay
  class PropertyType < ApplicationRecord
    validates :name, presence: true, uniqueness: { case_sensitive: false }
  end
end
