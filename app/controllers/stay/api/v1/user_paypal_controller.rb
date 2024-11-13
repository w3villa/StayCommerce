class Stay::Api::V1::UserPaypalController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!
  before_action :set_paypal, only: %i[show edit update]

  def index
    @paypal = current_devise_api_user.user_paypal
    if @paypal.present?
      render json: {
        message: "paypal account found",
        data: @paypal,
        success: true },
      status: :ok
    else
      render json: { error: "No paypal account found", success: false }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: @paypal, success: true }, status: :ok
  end

  def create
    paypal = current_devise_api_user.build_user_paypal(user_paypal_params)
    if paypal.save
      render json: { message: "PayPal account saved successfully", data: paypal, success: true }, status: :ok
    else
      render json: { error: "PayPal account not saved", success: false, errors: paypal.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def edit
    render json: { data: paypal, success: true }, status: :ok
  end

  def update
    if @paypal.update(user_paypal_params)
      render json: { message: "Credit card updated successfully", data: @paypal, success: true }, status: :ok
    else
      render json: { error: "Credit card not updated", success: false, errors: paypal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_paypal
    @paypal = current_devise_api_user.user_paypal
  end

  def user_paypal_params
    params.require(:user_paypal).permit(:email, :user_id)
  end
end
