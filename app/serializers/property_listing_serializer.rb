class PropertyListingSerializer < ActiveModel::Serializer
  attributes :id, :title, :price_per_month, :place_images, :total_rooms,
              :availability_end, :availability_start, :extra_guest, :latitude,
              :longitude, :address, :city, :state, :country, :active, :property_state, :is_favorite

  belongs_to :property_category, Serializer: :PropertyCategorySerializer
  belongs_to :property_type, Serializer: :PropertyTypeSerializer


  def place_images
    object.place_images.attached? ? object.place_images_urls : []
  end

  def is_favorite
    scope && scope[:current_user].present? && scope[:current_user].favorites.exists?(id: object.id)
  end
end
