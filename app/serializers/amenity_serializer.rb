class AmenitySerializer < ActiveModel::Serializer

  attributes :id, :name, :amenity_type

  belongs_to :amenity_category, serializer: AmenityCategorySerializer
  # has_many :properties, serializer: PropertySerializer

end