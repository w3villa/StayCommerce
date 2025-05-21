class Stay::Api::V1::FeaturesController < Stay::BaseApiController
  def property
    features = Stay::Feature.property
    if features.any?
    render json: { data: ActiveModelSerializers::SerializableResource.new(features, each_serializer: PropertyFeatureSerializer), success: true }, status: :ok
    else
      render json: { error: "no feature found", success: false }, status: :unprocessable_entity
    end
  end

  def room
    features = Stay::Feature.room
    if features.any?
      render json: { data: ActiveModelSerializers::SerializableResource.new(features, each_serializer: PropertyFeatureSerializer), success: true }, status: :ok
    else
      render json: { error: "no feature found", success: false }, status: :unprocessable_entity
    end
  end
end
