class Stay::Api::V1::PaymentsController < Stay::BaseApiController
  include Stay::StripeConcern

    before_action :set_booking, except: :payment_method
    before_action :authenticate_devise_api_token!


    def payment_method
      methods =  Stay::PaymentMethod.all
      if methods.any?
        render json: { message: "Payment Method Found", data: methods, success: true }, status: :ok
      else
        render json: { error: "no method found", success: false }, status: :unprocessable_entity
      end
    end

    def create_payment_method
      payment_method = create_payment_method(payment_method_params)
      attach_payment_method(payment_method.id)
      render json: { message: "Payment method created and attached successfully.", payment_method: payment_method }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def list_payment_methods
      payment_methods = list_payment_methods
      render json: { payment_methods: payment_methods.data }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def create
      begin
        customer = create_or_retrieve_customer
    
        payment_intent = if @booking.payment_intent_id && @booking.payment_state == "confirmed"
                           get_payment_intent
                         else
                           create_payment_intent
                         end
    
        payment_status = case payment_intent.status
                         when "succeeded"
                           "confirmed"
                         when "requires_action"
                           "pending"
                         else
                           "failed"
                         end
        create_payment(payment_intent, payment_status, @booking)
        @booking.update(payment_intent_id: payment_intent.id, payment_state:payment_status)
    
        if payment_intent.status == "requires_action"
          render json: {
            message: "Payment requires further action",
            client_secret: payment_intent.client_secret,
            payment_intent_id: payment_intent.id
          }, status: :ok
        elsif payment_intent.status == "succeeded"
          render json: {
            message: "Payment successful",
            payment_intent: payment_intent
          }, status: :ok
        else
          render json: {
            message: "Payment failed",
            error: payment_intent.last_payment_error
          }, status: :unprocessable_entity
        end
      rescue Stripe::CardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end
    
    def create_payment(payment_intent, status, booking)
      Stay::Payment.create!(
        booking: booking,
        payment_method: Stay::PaymentMethod.last,
        amount: booking.total_amount,
        state: status,
      )
    end

    def confirm
      payment_intent = get_payment_intent
      if payment_intent.status == "succeeded"
        @booking.update(status: "completed")
        render json: { success: true, redirect_url: params[:redirect_url] }
      else
        render json: { error: payment_intent.last_payment_error.message }, status: 422
      end
    end

    private


    def payment_params
      params.require(:payment).permit(:amount, :currency, :payment_method_id, :description, :customer_email)
    end

    def set_booking
      @booking = Stay::Booking.find(params[:booking_id])
    end
end
