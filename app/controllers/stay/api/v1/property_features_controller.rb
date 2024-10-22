class Stay::Api::V1::PropertyFeaturesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def index
    features = Stay::PropertyFeature.all
    render json: { property_features: ActiveModelSerializers::SerializableResource.new(features, each_serializer: PropertyFeatureSerializer) }
  end
end
