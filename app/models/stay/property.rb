module Stay
  class Property < ApplicationRecord
    has_many :rooms, class_name: 'Stay::Room', dependent: :destroy
    has_many :chats, class_name: 'Stay::Chat', dependent: :destroy

    belongs_to :user, class_name: 'Stay::User', optional: true
    # belongs_to :address, class_name: 'Stay::Address', optional: true
    has_one :address, class_name: 'Stay::Address', dependent: :destroy
    has_many_attached :images

    has_many :prices, through: :rooms

    has_many :line_items
    has_many :bookings, through: :line_items
    after_create :create_default_room
    after_destroy :destroy_default_room

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
      rooms.find_by(is_master: true)
    end

    private

    def create_default_room
      rooms.create(is_master: true, property_id: self.id, max_guests: 2, price_per_night: 0.0, room_type_id: Stay::RoomType.first.id, status: 'available')
    end

    def destroy_default_room
      default_room&.destroy
    end
  end
end
