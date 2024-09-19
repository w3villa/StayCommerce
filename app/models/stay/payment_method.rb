module Stay
  class PaymentMethod < ApplicationRecord
    DISPLAY = [:both, :front_end, :back_end].freeze

    has_many :payments, class_name: 'Stay::Payment', dependent: :destroy

    scope :active,                 -> { where(active: true).order(position: :asc) }
    scope :available,              -> { active.where(display_on: [:front_end, :back_end, :both]) }
    scope :available_on_front_end, -> { active.where(display_on: [:front_end, :both]) }
    scope :available_on_back_end,  -> { active.where(display_on: [:back_end, :both]) }
  end
end
