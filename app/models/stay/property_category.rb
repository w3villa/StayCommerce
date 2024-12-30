module Stay
  class PropertyCategory < ApplicationRecord
    has_many :properties, class_name: "Stay::Property", dependent: :nullify
    validates :name,  presence: true, uniqueness: { case_sensitive: false }, format: { without: /\s/, message: "must contain no spaces" }
  end
end
