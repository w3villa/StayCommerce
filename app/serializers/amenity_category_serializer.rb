class AmenityCategorySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :amenities, serializer: AmenitySerializer

  def initialize(object, options = {})
    super
    @type = options[:type]
  end
  
  def amenities
    object.amenities.where(amenity_type: @type)
  end
end