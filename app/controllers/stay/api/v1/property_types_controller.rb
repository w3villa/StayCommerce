class Stay::Api::V1::PropertyTypesController < Stay::BaseApiController

  def index
    @type = Stay::PropertyType.all
    render json:{data: ActiveModelSerializers::SerializableResource.new(@type, each_serializer: PropertyTypeSerializer), message: "data found", success: true}, status: :ok
  end

  def show
    @type = Stay::PropertyType.find_by(id: params[:id])
    return render json:{error: "no data found", success: false}, status: :unprocessable_entity if @type.nil?
    render json:{data:  PropertyTypeSerializer.new(@type), message: "data found", success: true},  status: :ok
  end

end