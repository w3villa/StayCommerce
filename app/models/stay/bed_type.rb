module Stay
  class BedType < ApplicationRecord
    has_many :rooms, class_name: "Stay::Room"

    validates :name, presence: true, uniqueness: { case_sensitive: false }
  end
end
