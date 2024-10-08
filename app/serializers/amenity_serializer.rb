class Amenityerializer < ActiveModel::Serializer

  attributes :id ,:name
  belongs_to :amenity_category

end