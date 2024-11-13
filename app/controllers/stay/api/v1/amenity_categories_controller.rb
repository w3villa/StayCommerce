class Stay::Api::V1::AmenityCategoriesController < ApplicationController
  before_action :authenticate_devise_api_token!

  def property
    amenities = Stay::AmenityCategory.all
    render json: { data:ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenityCategorySerializer, type:"property") }
  end

  def room
    amenities = Stay::AmenityCategory.all
    render json: { data:ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenityCategorySerializer, type:"room") }
  end
end
