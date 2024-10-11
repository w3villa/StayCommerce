class PropertyListingSerializer < ActiveModel::Serializer
  attributes :id, :title, :price_per_night, :place_images, :price_per_night, :total_rooms,
              :availability_end, :availability_start, :extra_guest, :latitude, :longitude

  def place_images
    object.place_images.attached? ? object.place_images_urls : []
  end
end