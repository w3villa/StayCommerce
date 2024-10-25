class Stay::Api::V1::BedTypesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def index
    @bed_type = Stay::BedType.all
    return render json: { error: "no data found", success: false }, status: :unprocessable_entity unless @bed_type.any?
    render json: { message: "bed type found", data:  ActiveModelSerializers::SerializableResource.new(@bed_type, each_serializer: BedTypeSerializer), success: true }, status: :ok
  end
end
