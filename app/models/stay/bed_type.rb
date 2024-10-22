module Stay
  class BedType < ApplicationRecord
    has_many :rooms, class_name: 'Stay::Room'

    validates :name, presence: true
  end
end
