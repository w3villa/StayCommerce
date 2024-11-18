class PropertyListingSerializer < ActiveModel::Serializer
  attributes :id, :title, :price_per_month, :place_images, :total_rooms,
              :availability_end, :availability_start, :extra_guest, :latitude, :longitude, :address, :city, :state, :country

  def place_images
    object.place_images.attached? ? object.place_images_urls : []
  end
end