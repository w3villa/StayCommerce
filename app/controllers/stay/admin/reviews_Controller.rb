module Stay
  module Admin
    class ReviewsController < Stay::Admin::BaseController
      before_action :set_review, only: %i[show edit update destroy]

      # GET /reviews
      def index
        @reviews = Stay::Review.page(params[:page])
      end

      # GET /reviews/1
      def show
      end

      # GET /reviews/new
      def new
        @review = Stay::Review.new
      end

      # GET /reviews/1/edit
      def edit
      end

      # POST /reviews
      def create
        @review = Stay::Review.new(review_params)

        if @review.save
          redirect_to admin_review_path(@review), notice: 'Review was successfully created.'
        else
          render :new
        end
      end

      # PATCH/PUT /reviews/1
      def update
        if @review.update(review_params)
          redirect_to admin_review_path(@review), notice: 'Review was successfully updated.'
        else
          render :edit
        end
      end

      # DELETE /reviews/1
      def destroy
        @review.destroy
        redirect_to admin_reviews_url, notice: 'Review was successfully destroyed.'
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_review
        @review = Stay::Review.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def review_params
        params.require(:review).permit(:booking_id, :rating, :comment)
      end
    end
  end
end
