module Stay
  module Admin
    class PaymentMethodsController < Stay::Admin::BaseController
      before_action :set_payment_method, only: %i[show edit update destroy]

      def index
        @payment_methods = Stay::PaymentMethod.all
      end

      def show
      end

      def new
        @payment_method = Stay::PaymentMethod.new
      end

      def create
        @payment_method = Stay::PaymentMethod.new(payment_method_params)
        if @payment_method.save
          redirect_to admin_payment_method_path(@payment_method), notice: 'Payment method was successfully created.'
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @payment_method.update(payment_method_params)
          redirect_to admin_payment_method_path(@payment_method), notice: 'Payment method was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        @payment_method.destroy
        redirect_to admin_payment_methods_url, notice: 'Payment method was successfully destroyed.'
      end

      private

      def set_payment_method
        @payment_method = Stay::PaymentMethod.find(params[:id])
      end

      def payment_method_params
        params.require(:payment_method).permit(:name)
      end
    end
  end
end
