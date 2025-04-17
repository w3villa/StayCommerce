class Stay::Api::V1::PropertyTypesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def index
    property_types = Stay::PropertyType.all

    if property_types.exists?
      serialized_data = ActiveModelSerializers::SerializableResource.new(property_types, each_serializer: PropertyTypeSerializer)

      render json: {
        data: serialized_data,
        message: "Property types found",
        success: true
      }, status: :ok
    else
      render json: {
        data: [],
        message: "No property types found",
        success: false
      }, status: :not_found
    end
  rescue => e
    render json: {
      error: "Failed to fetch property types",
      message: e.message,
      success: false
    }, status: :internal_server_error
  end

  def show
    type = Stay::PropertyType.find_by(id: params[:id])

    if type.present?
      render json: {
        data: PropertyTypeSerializer.new(type),
        message: "Property type found",
        success: true
      }, status: :ok
    else
      render json: {
        data: {},
        message: "Property type not found",
        success: false
      }, status: :not_found
    end
  rescue => e
    render json: {
      error: "Failed to fetch property type",
      message: e.message,
      success: false
    }, status: :internal_server_error
  end
end
