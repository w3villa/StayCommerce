class Stay::Api::V1::FeaturesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def property
    features = Stay::Feature.property

    if features.exists?
      render json: {
        success: true,
        data: ActiveModelSerializers::SerializableResource.new(features, each_serializer: FeatureSerializer)
      }, status: :ok
    else
      render json: {
        success: false,
        message: "No property features found"
      }, status: :not_found
    end
  rescue => e
    render json: {
      success: false,
      error: "Failed to fetch property features",
      message: e.message
    }, status: :internal_server_error
  end

  def room
    features = Stay::Feature.room

    if features.exists?
      render json: {
        success: true,
        data: ActiveModelSerializers::SerializableResource.new(features, each_serializer: FeatureSerializer)
      }, status: :ok
    else
      render json: {
        success: false,
        message: "No room features found"
      }, status: :not_found
    end
  rescue => e
    render json: {
      success: false,
      error: "Failed to fetch room features",
      message: e.message
    }, status: :internal_server_error
  end
end
