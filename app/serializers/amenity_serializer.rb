class AmenitySerializer < ActiveModel::Serializer

  attributes :id, :name

  belongs_to :amenity_category, serializer: AmenityCategorySerializer
  # has_many :properties, serializer: PropertySerializer

end