module Stay
  class CancellationPolicy < ApplicationRecord
    has_many :properties, class_name: "Stay::Property", dependent: :nullify
  end
end
