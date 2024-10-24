class AmenityCategorySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :amenities, Serializer: :Amenityerializer
end