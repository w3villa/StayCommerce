class Stay::Api::V1::AmenitiesController < ApplicationController
  def property
    amenities = Stay::Amenity.property

    if amenities.exists?
      render json: {
        success: true,
        data: ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenitySerializer)
      }, status: :ok
    else
      render json: {
        success: false,
        message: "No property amenities found"
      }, status: :not_found
    end
  rescue => e
    render json: {
      success: false,
      error: "Failed to fetch property amenities",
      message: e.message
    }, status: :internal_server_error
  end

  def room
    amenities = Stay::Amenity.room

    if amenities.exists?
      render json: {
        success: true,
        data: ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenitySerializer)
      }, status: :ok
    else
      render json: {
        success: false,
        message: "No room amenities found"
      }, status: :not_found
    end
  rescue => e
    render json: {
      success: false,
      error: "Failed to fetch room amenities",
      message: e.message
    }, status: :internal_server_error
  end
end
