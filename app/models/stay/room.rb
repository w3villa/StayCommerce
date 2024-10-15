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

    has_many :room_features, class_name: "Stay::RoomFeature", dependent: :destroy
    has_many :features, through: :room_features, class_name: "Stay::Feature"

    has_many :room_amenities, class_name: "Stay::RoomAmenity", dependent: :destroy
    has_many :amenities, through: :room_amenities, class_name: "Stay::Amenity"

    accepts_nested_attributes_for :room_features, allow_destroy: true
    accepts_nested_attributes_for :room_amenities, allow_destroy: true

    after_create :set_price
    after_update :update_price, if: :saved_change_to_price_per_night?
    belongs_to :bed_type, class_name: "Stay::BedType", optional: :true

    validate :booking_dates_are_valid

    def price
      price_per_night
    end

    def images_urls
      images.map { |image| Rails.application.routes.url_helpers.url_for(image) }
    end

    private

    def booking_dates_are_valid
      if booking_start && booking_end && booking_start >= booking_end
        errors.add(:booking_end, "must be after availability start date")
      end
    end

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
