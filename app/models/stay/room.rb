module Stay
  class Room < ApplicationRecord
    include CurrencyHelper
    STATUSES = %w[active inactive].freeze

    belongs_to :property, class_name: "Stay::Property"
    belongs_to :room_type, class_name: "Stay::RoomType"
    belongs_to :bed_type, class_name: "Stay::BedType", optional: :true
    has_many :bookings, class_name: "Stay::Booking"
    has_many_attached :room_images
    has_many :line_items, class_name: "Stay::LineItem"
    has_many :prices,
             class_name: "Stay::Price",
             dependent: :destroy

    has_many :room_features, class_name: "Stay::RoomFeature", dependent: :destroy
    has_many :features, through: :room_features, class_name: "Stay::Feature"

    has_many :room_amenities, class_name: "Stay::RoomAmenity", dependent: :destroy
    has_many :amenities, through: :room_amenities, class_name: "Stay::Amenity"

    accepts_nested_attributes_for :room_features, allow_destroy: true
    accepts_nested_attributes_for :room_amenities, allow_destroy: true

    after_create :set_price
    after_update :update_price, if: :saved_change_to_price_per_month?
    validates :status, presence: true, inclusion: { in: STATUSES, message: "%{value} is not a valid status" }
    validate :booking_dates_are_valid
    validate :room_count_limit

    # state_machine :status, initial: :active do
    #   state :active
    #   state :booked
    #   state :inactive

    #   event :book do
    #     transition active: :booked
    #   end

    #   event :deactivate do
    #     transition [:booked, :active] => :inactive
    #   end

    #   event :activate do
    #     transition inactive: :active
    #   end
    # end


    def price
      price_per_month
    end

    def images_urls
      room_images.map { |image| image.url }
    end

    private

    def booking_dates_are_valid
      if booking_start && booking_end && booking_start >= booking_end
        errors.add(:booking_end, "must be after availability start date")
      end
    end

    def room_count_limit
      if property.rooms.count >= property.total_rooms
        errors.add(:base, "You cannot create more rooms than the property's total room count.")
      end
    end

    def set_price
      prices.create(amount: price_per_month, currency: Stay::Store.default.default_currency) if price_per_month.present? && !is_master
    end

    def update_price
      price = prices.find_or_initialize_by(currency: Stay::Store.default.default_currency)
      price.amount = price_per_month
      price.save
    end
  end
end
