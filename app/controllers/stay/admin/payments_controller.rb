module Stay
  module Admin
    class PaymentsController < Stay::Admin::BaseController
      before_action :set_payment, only: %i[show edit update destroy]

      # GET /payments
      def index
        @payments = Stay::Payment.all
      end

      # GET /payments/1
      def show
      end

      # GET /payments/new
      def new
        @payment = Stay::Payment.new
      end

      # GET /payments/1/edit
      def edit
      end

      # POST /payments
      def create
        @payment = Stay::Payment.new(payment_params)

        if @payment.save
          redirect_to admin_payment_path(@payment), notice: 'Payment was successfully created.'
        else
          render :new
        end
      end

      # PATCH/PUT /payments/1
      def update
        if @payment.update(payment_params)
          redirect_to admin_payment_path(@payment), notice: 'Payment was successfully updated.'
        else
          render :edit
        end
      end

      # DELETE /payments/1
      def destroy
        @payment.destroy
        redirect_to admin_payments_url, notice: 'Payment was successfully destroyed.'
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_payment
        @payment = Stay::Payment.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def payment_params
        params.require(:payment).permit(:booking_id, :payment_method_id, :amount, :state)
      end
    end
  end
end
