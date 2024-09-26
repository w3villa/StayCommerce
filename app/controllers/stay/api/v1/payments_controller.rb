class Stay::Api::V1::PaymentsController < Stay::BaseApiController
    include StripeConcern

    before_action :set_booking
    # before_action :validate_payment_params, only: :create
    
    def create
        begin
            customer = create_or_retrieve_customer
            payment_intent = @booking.payment_intent_id ? get_payment_intent : create_payment_intent.tap { |pi| @booking.update(payment_intent_id: pi.id) }
            if params[:confirm]
                if payment_intent.status == 'succeeded'
                    render json: { message: "Payment successful", payment_intent: payment_intent }, status: :ok
                elsif payment_intent.status == 'requires_action'
                    render json: { message: "Payment requires further action", client_secret: payment_intent.client_secret }, status: :ok
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
  
  
    def complete
      payment_intent = retrieve_payment_intent_from_params
      if payment_intent.status == 'succeeded' 
          if @payment
              @payment.update(payment_status: payment_intent.status, payment_date: Time.zone.now, amount: payment_intent.amount, payment_method: payment_intent.payment_method_types[0])
          else 
              finalize_payment(payment_intent)
              @payment.update(payment_status: payment_intent.status, payment_date: Time.zone.now, amount: payment_intent.amount, payment_method: payment_intent.payment_method_types[0])
              @payment.booking.update(status: 'booked')
          end
  
        redirect_to root_path, notice: 'Payment completed successfully!'
      else
        redirect_to order_failure_path, alert: 'Payment failed or was not completed.'
      end
  
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to new_payment_path
    end

  
    private

    def validate_payment_params
      required_params = [:amount, :currency, :payment_method_id, :customer_email]
      required_params.each do |param|
        unless payment_params[param].present?
          render json: { error: "#{param} is required" }, status: :unprocessable_entity
        end
      end
    end
  
    def payment_params
      params.require(:payment).permit(:amount, :currency, :payment_method_id, :description, :customer_email)
    end
    
    def set_booking
      @booking = Stay::Booking.find(params[:booking_id])
    end

  end

