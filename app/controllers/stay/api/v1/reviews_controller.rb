class Stay::Api::V1::ReviewsController < Stay::BaseApiController
  before_action :set_review, only: [:show, :update, :destroy]

  def index
    @reviews = Stay::Review.all
    render json: @reviews
  end

  def show
    render json: @review
  end

  def create
    @review = Stay::Review.new(review_params)
    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @review.destroy     
      head :no_content
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def set_review
    @review = Stay::Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:booking_id, :rating, :comment)
  end
end
