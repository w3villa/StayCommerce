module Stay
  class Property < ApplicationRecord
    include Rails.application.routes.url_helpers
    include CurrencyHelper
    include Stay::ControllerHelpers::Currency
    include Stay::ControllerHelpers::Store

    has_one :master, -> { where is_master: true }, class_name: "Stay::Room", dependent: :destroy
    has_many :rooms, class_name: "Stay::Room", dependent: :destroy
    has_many :rooms_including_master,
         inverse_of: :property,
         class_name: "Stay::Room",
         dependent: :destroy

    has_many :chats, class_name: "Stay::Chat", dependent: :destroy

    belongs_to :user, class_name: "Stay::User", optional: true
    # belongs_to :address, class_name: 'Stay::Address', optional: true

    has_one_attached :cover_image
    has_many_attached :place_images
    has_many :prices, through: :rooms

    has_many :line_items, through: :variants_including_master
    has_many :bookings, through: :line_items

    belongs_to :property_category, class_name: "Stay::PropertyCategory", optional: true
    belongs_to :property_type, class_name: "Stay::PropertyType"
    has_many :property_amenities, class_name: "Stay::PropertyAmenity", dependent: :destroy
    has_many :amenities, through: :property_amenities, class_name: "Stay::Amenity"
    has_many :additional_rules, class_name: "Stay::AdditionalRule", dependent: :destroy
    has_many :property_house_rules, class_name: "Stay::PropertyHouseRule", dependent: :destroy
    has_many :house_rules, through: :property_house_rules, class_name: "Stay::HouseRule"
    has_many :property_features, class_name: "Stay::PropertyFeature", dependent: :destroy
    has_many :features, through: :property_features, class_name: "Stay::Feature"
    has_many :property_taxes, class_name: "Stay::PropertyTax", dependent: :destroy
    has_many :taxes, through: :property_taxes, class_name: "Stay::Tax"

    # nested_attributes
    accepts_nested_attributes_for :property_amenities, allow_destroy: true
    accepts_nested_attributes_for :additional_rules, allow_destroy: true
    accepts_nested_attributes_for :rooms, allow_destroy: true
    accepts_nested_attributes_for :property_house_rules, allow_destroy: true
    accepts_nested_attributes_for :property_features, allow_destroy: true
    accepts_nested_attributes_for :property_taxes, allow_destroy: true

    geocoded_by :address
    after_validation :geocode

    has_many :store_properties, class_name: "Stay::StoreProperty", dependent: :destroy
    has_many :stores, through: :store_properties, class_name: "Stay::Store"
    # validates :latitude, format: { with: /\A-?([1-8]?\d(?:\.\d{1,})?|90(?:\.0{1,6})?)\z/ }
    # validates :longitude, format: { with: /\A-?((?:1[0-7]|[1-9])?\d(?:\.\d{1,})?|180(?:\.0{1,})?)\z/ }

    # attr_accessor :price_per_night
    # after_create :create_default_room
    # after_update :update_prices
    after_create :create_store_property
    validate :availability_dates_are_valid

    # def self.ransackable_attributes(auth_object = nil)
    #   ["id", "name", "created_at", "updated_at"]
    # end

    # def full_address
    #   [address].compact.join(' ')
    # end

    state_machine :property_state, initial: :waiting_for_approval do
      state :waiting_for_approval
      state :approved
      state :rejected

      event :approve do
        transition waiting_for_approval: :approved
      end

      event :reject do
        transition waiting_for_approval: :rejected
      end

      event :resubmit do
        transition rejected: :waiting_for_approval
      end

      # after_transition on: :approve do |property|
      #   property.notify_user("Your property has been approved!")
      # end

      # after_transition on: :reject do |property|
      #   property.notify_user("Your property has been rejected.")
      # end

      # after_transition on: :resubmit do |property|
      #   property.notify_admin("Property has been resubmitted for approval.")
      # end
    end

    # def notify_user(message)
    #   puts message
    # end

    # def notify_admin(message)
    #   puts message
    # end

    def self.ransackable_attributes(auth_object = nil)
      [ "active", "address", "availability_end", "availability_start", "title", "extra_guest", "total_rooms", "total_bathrooms", "latitude", "longitude" ]
    end


    def self.ransackable_associations(auth_object = nil)
      [ "rooms" ]
    end


    def has_rooms?
      rooms.any?
    end

    def deleted?
      !!deleted_at
    end

    def average_rating
      all_reviews = Stay::Review.joins(booking: { rooms: :property }).where(stay_properties: { id: self.id })

      return 0 if all_reviews.empty?
      total_rating = all_reviews.sum(:rating)
      review_count = all_reviews.count

      (total_rating.to_f / review_count).round(2)
    end

    def reviews_count
      Stay::Review.joins(booking: { rooms: :property }).where(stay_properties: { id: self.id }).count
    end

    def default_room
      master
    end

    def price
      master&.price_per_night.to_f || 0
    end

    def place_images_urls
      place_images.map { |image| Rails.application.routes.url_helpers.url_for(image) }
    end

    def cover_image_url
      cover_image.attached? ? url_for(cover_image) : nil
    end

    def approved
      transaction do
        approve!
      end
    end

    def rejected
      transaction do
        reject!
      end
    end

    def resubmited
      transaction do
        resubmit!
      end
    end

    private

    def availability_dates_are_valid
      if availability_start && availability_end && availability_start >= availability_end
        errors.add(:availability_end, "must be after availability start date")
      end
    end

    def create_store_property
      return unless current_store.present?
      StoreProperty.create(store_id: current_store.id, property_id: self.id)
    end

    def create_default_room
      return unless Stay::RoomType.first.present?
      master_room = rooms.create!(is_master: true, property_id: self.id, max_guests: 2, price_per_night: price_per_night, room_type_id: Stay::RoomType.first&.id, status: "available")
      master_room.prices.create(amount: master_room.price_per_night, currency: Stay::Store.default.default_currency)
    end

    def update_prices
      master&.prices&.update(amount: master.price_per_night, currency: Stay::Store.default.default_currency)
    end
  end
end
