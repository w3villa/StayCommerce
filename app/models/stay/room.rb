module Stay
  class Room < ApplicationRecord
    belongs_to :property, class_name: 'Stay::Property'
    belongs_to :room_type, class_name: 'Stay::RoomType'
    has_many :bookings, class_name: 'Stay::Booking'
    has_many_attached :images
    has_many :line_items, class_name: 'Stay::LineItem'
    has_many :prices,
             class_name: 'Stay::Price',
             dependent: :destroy

    after_create :set_price

    def price
      price_per_night
    end

    private

    def set_price
      prices.create(amount: price_per_night, currency: Rails.application.config.default_currency) if price_per_night.present? && !is_master
    end
  end
end
