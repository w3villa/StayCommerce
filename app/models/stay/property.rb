module Stay
  class Property < ApplicationRecord
    STATUSES = %w[active inactive].freeze
    ACTIVE_STATUS = "active".freeze
    APPROVED = "approved".freeze
    PROPERTY = "property".freeze
    include Rails.application.routes.url_helpers
    include CurrencyHelper
    include Stay::ControllerHelpers::Currency
    include Stay::ControllerHelpers::Store
    extend FriendlyId
    acts_as_paranoid

    friendly_id :title, use: :slugged

    validates :title, presence: true, uniqueness: { case_sensitive: false, error: "Title has already been taken" }
    validate :availability_dates_are_valid
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

    has_many :prices, through: :rooms
    has_many :line_items, through: :variants_including_master
    has_many :bookings
    belongs_to :property_category, class_name: "Stay::PropertyCategory"
    belongs_to :property_type, class_name: "Stay::PropertyType"
    has_many :property_amenities, class_name: "Stay::PropertyAmenity", dependent: :destroy
    has_many :property_type_amenities, -> { where(amenity_type: PROPERTY) }, through: :property_amenities, source: :amenity, class_name: "Stay::Amenity"
    has_many :additional_rules, class_name: "Stay::AdditionalRule", dependent: :destroy
    has_many :property_house_rules, class_name: "Stay::PropertyHouseRule", dependent: :destroy
    has_many :house_rules, through: :property_house_rules, class_name: "Stay::HouseRule"
    has_many :property_features, class_name: "Stay::PropertyFeature", dependent: :destroy
    has_many :property_type_features,-> { where(feature_type: PROPERTY) },through: :property_features,source: :feature, class_name: "Stay::Feature"
    has_many :property_taxes, class_name: "Stay::PropertyTax", dependent: :destroy
    has_many :taxes, through: :property_taxes, class_name: "Stay::Tax"
    has_many :store_properties, class_name: "Stay::StoreProperty", dependent: :destroy
    has_many :stores, through: :store_properties, class_name: "Stay::Store"

    # images
    has_one_attached :cover_image
    has_many_attached :place_images

    # nested_attributes
    accepts_nested_attributes_for :property_amenities, allow_destroy: true
    accepts_nested_attributes_for :additional_rules, allow_destroy: true
    accepts_nested_attributes_for :rooms, allow_destroy: true
    accepts_nested_attributes_for :property_house_rules, allow_destroy: true
    accepts_nested_attributes_for :property_features, allow_destroy: true
    accepts_nested_attributes_for :property_taxes, allow_destroy: true

    after_restore :restore_associated_rooms
    after_restore :restore_active_storage_files
    after_update :update_prices
    after_create :create_store_property
    geocoded_by :combine_address
    after_validation :geocode

    # scopes
    scope :approved, -> { where(property_state: APPROVED) }
    scope :active, -> { where(active: true) }
    scope :similar_properties, ->(type_id, category_id, property_id) {
      where(property_type_id: type_id, property_category_id: category_id)
      .where.not(id: property_id)
    }

    scope :with_features, ->(feature_ids) {
      joins(:features).where(stay_features: { id: feature_ids }).distinct
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

    scope :price_filter, ->(min_price, max_price) {
      joins(:rooms).where(stay_rooms: { price_per_month: min_price..max_price })
    }

    scope :by_property_category, ->(property_category_id) {
      joins(:property_category).where(property_category: { id: property_category_id })
    }

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
      %w[active address availability_end availability_start title extra_guest total_rooms total_bathrooms latitude longitude total_bedrooms guest_number]
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

    def restore_active_storage_files
      place_images.each do |image|
        Rails.logger.error "Missing file for #{image.filename}" unless File.exist?(ActiveStorage::Blob.service.path_for(image.blob.key))
      end
    end

    def restore_associated_rooms
      rooms.only_deleted.each(&:restore)
    end

    def availability_dates_are_valid
      if availability_start && availability_end && availability_start >= availability_end
        errors.add(:availability_end, "must be after availability start date")
      end
    end

    def create_store_property
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
