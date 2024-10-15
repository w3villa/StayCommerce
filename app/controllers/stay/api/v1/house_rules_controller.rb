class Stay::Api::V1::HouseRulesController < Stay::BaseApiController

  def index
    @rules = Stay::HouseRule.all
    return render json:{error: "no data found", success: false}, status: :unprocessable_entity unless @rules.any?
    render json:{message: "house rule found", data:  ActiveModelSerializers::SerializableResource.new(@rules, each_serializer: HouseRulesSerializer), success: true}, status: :ok
  end

end