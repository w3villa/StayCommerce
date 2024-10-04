module Stay
  class Room < ApplicationRecord
    include CurrencyHelper

    belongs_to :property, class_name: 'Stay::Property'
    belongs_to :room_type, class_name: 'Stay::RoomType'
    has_many :bookings, class_name: 'Stay::Booking'
    has_many_attached :images
    has_many :line_items, class_name: 'Stay::LineItem'
    has_many :prices,
             class_name: 'Stay::Price',
             dependent: :destroy

    after_create :set_price
    after_update :update_price, if: :saved_change_to_price_per_night?

    def price
      price_per_night
    end

    private

    def set_price
      prices.create(amount: price_per_night, currency: Stay::Store.default.default_currency) if price_per_night.present? && !is_master
    end

    def update_price
      price = prices.find_or_initialize_by(currency: Stay::Store.default.default_currency)
      price.amount = price_per_night
      price.save
    end
  end
end
