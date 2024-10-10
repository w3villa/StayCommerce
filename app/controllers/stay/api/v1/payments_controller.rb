class Stay::Api::V1::PaymentsController < Stay::BaseApiController
  include Stay::StripeConcern

    before_action :set_booking
    
    def create
        begin
            customer = create_or_retrieve_customer
            payment_intent = @booking.payment_intent_id ? get_payment_intent : create_payment_intent.tap { |pi| @booking.update(payment_intent_id: pi.id) }
            if params[:confirm]
                if payment_intent.status == 'succeeded'
                    render json: { message: "Payment successful", payment_intent: payment_intent }, status: :ok
                elsif payment_intent.status == 'requires_action'
                    render json: { message: "Payment requires further action", client_secret: payment_intent.client_secret, payment_intent_id: payment_intent["id"] }, status: :ok
                else
                    render json: { message: "Payment failed", error: payment_intent.last_payment_error }, status: :unprocessable_entity
                end
            else 
                render json: {payment_intent: payment_intent, client_secret: payment_intent.client_secret}, status: :ok
            end
        rescue Stripe::CardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        rescue => e
          render json: { error: "Something went wrong" }, status: :internal_server_error
        end
    end
  
    def confirm
      payment_intent = get_payment_intent
      if payment_intent.status == 'succeeded'
        @booking.update(status: 'completed')
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

