class Stay::Api::V1::PropertyTypesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def index
    property_types = Stay::PropertyType.all
  
    if property_types.any?
      serialized_data = ActiveModelSerializers::SerializableResource.new(property_types, each_serializer: PropertyTypeSerializer)
  
      render json: {
        data: serialized_data,
        message: "Data found",
        success: true
      }, status: :ok
    else
      render json: {
        data: [],
        message: "No property types found",
        success: false
      }, status: :ok
    end
  end
  

  def show
    @type = Stay::PropertyType.find_by(id: params[:id])
    return render json: { error: "no data found", success: false }, status: :unprocessable_entity if @type.nil?
    render json: { data:  PropertyTypeSerializer.new(@type), message: "data found", success: true },  status: :ok
  end
end
