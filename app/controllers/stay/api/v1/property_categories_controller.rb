class Stay::Api::V1::PropertyCategoriesController < Stay::BaseApiController

  def index
    @type = Stay::PropertyCategory.all
    render json:{data: ActiveModelSerializers::SerializableResource.new(@type, each_serializer: PropertyCategorySerializer), message: "data found", success: true}, status: :ok
  end

  def show
    @type = Stay::PropertyCategory.find_by(id: params[:id])
    return render json:{error: "no data found", success: false}, status: :unprocessable_entity if @type.nil?
    render json:{data:  PropertyCategorySerializer.new(@type), message: "data found", success: true},  status: :ok
  end

end