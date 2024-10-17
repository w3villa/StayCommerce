class Stay::Api::V1::RoomTypesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def index
    @type = Stay::RoomType.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@type, each_serializer: RoomTypeSerializer), message: "data found", success: true }, status: :ok
  end

  def show
    @type = Stay::RoomType.find_by(id: params[:id])
    return render json: { error: "no data found", success: false }, status: :unprocessable_entity if @type.nil?
    render json: { data:  RoomTypeSerializer.new(@type), message: "data found", success: true },  status: :ok
  end
end
