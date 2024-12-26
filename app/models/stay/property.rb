module Stay
  class Property < ApplicationRecord
    include Rails.application.routes.url_helpers
    include CurrencyHelper
    include Stay::ControllerHelpers::Currency
    include Stay::ControllerHelpers::Store
    ACTIVE_STATUS = "active".freeze
    extend FriendlyId

    friendly_id :id_with_title, use: :slugged

    has_one :master, -> { where is_master: true }, class_name: "Stay::Room", dependent: :destroy
    has_many :rooms, -> { where(status: ACTIVE_STATUS) }, class_name: "Stay::Room", dependent: :destroy
    has_many :rooms_including_master,
         inverse_of: :property,
         class_name: "Stay::Room",
         dependent: :destroy

    belongs_to :cancellation_policy, class_name: "Stay::CancellationPolicy", optional: :true
    has_many :chats, class_name: "Stay::Chat", dependent: :destroy

    belongs_to :user, class_name: "Stay::User", optional: true
    # belongs_to :address, class_name: 'Stay::Address', optional: true

    has_one_attached :cover_image
    has_many_attached :place_images
    has_many :prices, through: :rooms

    has_many :line_items, through: :variants_including_master
    has_many :bookings

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

    # geocoded_by :combine_address
    # after_validation :geocode

    has_many :store_properties, class_name: "Stay::StoreProperty", dependent: :destroy
    has_many :stores, through: :store_properties, class_name: "Stay::Store"
    scope :approved, -> { where(property_state: "approved") }
    scope :active, -> { where(active: true) }

    scope :similar_properties, ->(type_id, category_id, property_id) {
      where(property_type_id: type_id, property_category_id: category_id)
        .where.not(id: property_id)
    }

    scope :with_amenities, ->(amenity_ids) {
      joins(:amenities).where(stay_amenities: { id: amenity_ids }).distinct
    }

    scope :nearby, ->(latitude, longitude, distance) {
      near([ latitude, longitude ], distance)
    }

    scope :by_property_type, ->(property_type_id) {
      joins(:property_type).where(property_type: { id: property_type_id })
    }

    attr_accessor :price_per_month
    after_create :create_default_room
    after_update :update_prices
    after_create :create_store_property
    validate :availability_dates_are_valid


    def id_with_title
      [
        truncated_title,
        [ truncated_title, truncated_description ]
      ]
    end

    def truncated_title
      title.split[0..9].join(" ")
    end

    def truncated_description
      description.split[0..5].join(" ")
    end

    def should_generate_new_friendly_id?
      title_changed?
    end

    def combine_address
      [ address, city, state, country ].compact.join(" ")
    end

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
    end

    def self.ransackable_scopes(auth_object = nil)
      %i[with_amenities nearby by_property_type]
    end

    def self.ransackable_attributes(auth_object = nil)
      %w[active address availability_end availability_start title extra_guest total_rooms total_bathrooms latitude longitude]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[rooms amenities property_type]
    end

    def shared_property
      property_type.present? ? property_type.name.casecmp?("shared property") : false
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
      master&.price_per_month.to_f || 0
    end

    def place_images_urls
      place_images.map { |image| image.url }
    end

    def cover_image_url
      cover_image.attached? ? cover_image.url : nil
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
      # room_attr.none? { |item| item == "0" } && room_attr.any? { |item| item.is_a?(ActionController::Parameters) && item[:id].present? }
      # room_attr.none? { |item| item == "0" } && room_attr.any? { |item| item.is_a?(ActionController::Parameters) && item[:id].present? }
      StoreProperty.create(store_id: current_store.id, property_id: self.id)
    end

    def create_default_room
      return unless Stay::RoomType.first.present?
      master_room = rooms.create!(is_master: true, property_id: self.id, max_guests: 2, price_per_month: price_per_month, room_type_id: Stay::RoomType.first&.id, status: "active")
      master_room.prices.create(amount: master_room.price_per_month, currency: Stay::Store.default.default_currency)
    end

    def update_prices
      master&.prices&.update(amount: master.price_per_month, currency: Stay::Store.default.default_currency)
    end
  end
end
