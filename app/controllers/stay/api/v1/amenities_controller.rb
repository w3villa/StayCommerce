class Stay::Api::V1::AmenitiesController < ApplicationController
  def property
    amenities = Stay::Amenity.where(amenity_type: "property").all
    render json: { data: ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenitySerializer) }
  end

  def room
    amenities = Stay::Amenity.where(amenity_type: "room").all
    render json: { data: ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenitySerializer) }
  end
end
