class Stay::Api::V1::TaxesController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!

  def index
    @tax = Stay::Tax.all
    return render json: { error: "no data found", success: false }, status: :unprocessable_entity unless @tax.any?
    render json: { data: ActiveModelSerializers::SerializableResource.new(@tax, each_serializer: TaxSerializer), message: "data found", success: true }, status: :ok
  end
end
