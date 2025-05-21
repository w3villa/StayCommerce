class AmenitySerializer < ActiveModel::Serializer
  attributes :id, :name, :amenity_type, :image

  def image
    cover_image.attached? ? cover_image.url : nil
  end
end
