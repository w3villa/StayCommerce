class Stay::Api::V1::CancellationPoliciesController < Stay::BaseApiController
  def index
    policies = Stay::CancellationPolicy.all
    render json: { data:ActiveModelSerializers::SerializableResource.new(policies, each_serializer: CancellationPolicySerializer), success: true }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cancellation policies not found" }, status: :not_found
  rescue StandardError => e
    render json: { error: "An unexpected error occurred", details: e.message }, status: :internal_server_error
  end
end
