class Stay::Api::V1::CreditCardsController < Stay::BaseApiController
  before_action :authenticate_devise_api_token!
  before_action :set_credit_card, only: %i[show edit update]

  def index
    @credit_cards = current_devise_api_user.credit_cards
    if @credit_cards.any?
      render json: {
        message: "Credit cards found",
        data: CreditCardSerializer.new(@credit_cards.last),
        success: true },
      status: :ok
    else
      render json: { error: "No credit cards found", success: false }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: CreditCardSerializer.new(@credit_card), success: true }, status: :ok
  end

  def new
    @credit_card = current_devise_api_user.credit_cards.build
    render json: { data: @credit_card, success: true }, status: :ok
  end

  def create
    @credit_card = current_devise_api_user.credit_cards.build(credit_card_params)
    if @credit_card.save
      render json: { message: "Credit card saved successfully", data: CreditCardSerializer.new(@credit_card), success: true }, status: :ok
    else
      render json: { error: "Credit card not saved", success: false, errors: @credit_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    render json: { data: @credit_card, success: true }, status: :ok
  end

  def update
    if @credit_card.update(credit_card_params)
      render json: { message: "Credit card updated successfully", data: CreditCardSerializer.new(@credit_card), success: true }, status: :ok
    else
      render json: { error: "Credit card not updated", success: false, errors: @credit_card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # def destroy
  #   @credit_card.destroy
  #   render json: { message: "Credit card successfully deleted", success: true }, status: :ok
  # end

  private

  def set_credit_card
    @credit_card = current_devise_api_user.credit_cards.find(params[:id])
  end

  def credit_card_params
    params.require(:credit_card).permit(:month, :year, :cc_number, :cc_type, :name)
  end
end
