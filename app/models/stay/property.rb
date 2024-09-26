module Stay
  class Property < ApplicationRecord
    has_one :master, -> { where is_master: true }, class_name: 'Stay::Room', dependent: :destroy
    has_many :rooms, class_name: 'Stay::Room', dependent: :destroy
    has_many :chats, class_name: 'Stay::Chat', dependent: :destroy

    belongs_to :user, class_name: 'Stay::User', optional: true
    belongs_to :address, class_name: 'Stay::Address', optional: true

    has_many_attached :images

    has_many :prices, through: :rooms

    has_many :line_items
    has_many :bookings, through: :line_items

    attr_accessor :price_per_night
    after_create :create_default_room

    # def self.ransackable_attributes(auth_object = nil)
    #   ["id", "name", "created_at", "updated_at"]
    # end
    def self.ransackable_attributes(auth_object = nil)
      ["active", "address_id", "availability_end", "availability_start"]
    end
  

    def self.ransackable_associations(auth_object = nil)
      ["address"]
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

    private

    def create_default_room
      master_room = rooms.create(is_master: true, property_id: self.id, max_guests: 2, price_per_night: price_per_night, room_type_id: Stay::RoomType.first&.id, status: 'available')
      master_room.prices.create(amount: master_room.price_per_night, currency: "USD")
    end
  end
end
