module Stay
  class Property < ApplicationRecord
    has_many :rooms, class_name: 'Stay::Room', dependent: :destroy
    has_many :chats, class_name: 'Stay::Chat', dependent: :destroy

    belongs_to :user, class_name: 'Stay::User', optional: true
    belongs_to :address, class_name: 'Stay::Address', optional: true
    has_many_attached :images


    def average_rating
      all_reviews = Stay::Review.joins(booking: :room).where(stay_rooms: { property_id: id })
      return 0 if all_reviews.empty?
      total_rating = all_reviews.sum(:rating)
      review_count = all_reviews.count
      (total_rating.to_f / review_count / 5 * 5).round(2)
    end 
    
    def reviews_count
      Stay::Review.joins(booking: :room).where(stay_rooms: { property_id: id }).count
    end

  end
end
