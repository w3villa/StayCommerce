class Stay::Api::V1::AmenityCategoriesController < ApplicationController
  before_action :authenticate_devise_api_token!

  def index
    amenities = Stay::AmenityCategory.all
    render json: { property: ActiveModelSerializers::SerializableResource.new(amenities, each_serializer: AmenityCategorySerializer) }
  end
end
