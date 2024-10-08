class Stay::Api::V1::AmenityCategoriesController < ApplicationController
  def index
    amenities = Stay::AmenityCategory.all
    render json: { property:ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenityCategorySerializer) }
  end
end
