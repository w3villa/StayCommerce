module Stay
  class BedType < ApplicationRecord
    has_many :rooms, class_name: "Stay::Room", dependent: :destroy

    validates :name,  presence: true, uniqueness: { case_sensitive: false }, format: { without: /\s/, error: "must contain no spaces" }
  end
end
