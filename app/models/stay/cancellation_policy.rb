module Stay
  class CancellationPolicy < ApplicationRecord
    has_many :properties, class_name: "Stay::Property", dependent: :nullify
    validates :name, presence: true, uniqueness: { case_sensitive: false }
  end
end
