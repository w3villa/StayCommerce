class Stay::Api::V1::PropertyCategoriesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def index
    categories = Stay::PropertyCategory.all

    if categories.exists?
      serialized_data = ActiveModelSerializers::SerializableResource.new(categories, each_serializer: PropertyCategorySerializer)
      render json: {
        data: serialized_data,
        message: "Property categories found",
        success: true
      }, status: :ok
    else
      render json: {
        data: [],
        message: "No property categories found",
        success: false
      }, status: :not_found
    end
  rescue => e
    render json: {
      error: "Failed to fetch property categories",
      message: e.message,
      success: false
    }, status: :internal_server_error
  end

  def show
    category = Stay::PropertyCategory.find_by(id: params[:id])

    if category.present?
      render json: {
        data: PropertyCategorySerializer.new(category),
        message: "Property category found",
        success: true
      }, status: :ok
    else
      render json: {
        data: {},
        message: "Property category not found",
        success: false
      }, status: :not_found
    end
  rescue => e
    render json: {
      error: "Failed to fetch property category",
      message: e.message,
      success: false
    }, status: :internal_server_error
  end
end
