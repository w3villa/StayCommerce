require "openssl"
require "base64"
require "dotenv/load"
module Stay
    module StripeConcern
      extend ActiveSupport::Concern

      included do
        Stripe.api_key = "sk_test_51LCfAAJQIRLPDLbLrmenImhOFwy8IDnaDrGXmAtt6W6eA0fQUeqZ1F876kLIOrvqfXtAvgF4jKDaabsKKhwOs6wN00qGX9nuE3"
      end

      def user
        current_devise_api_user || current_user
      end

      def create_payment_method
        Stripe::PaymentMethod.create({
          type: params[:payment_method_type],
          card: {
            number: params[:number],
            exp_month: params[:exp_month],
            exp_year: params[:exp_year],
            cvc: params[:cvc]
          }
        })
      end

      def create_customer
       customer =  Stripe::Customer.create({
          email: user.email,
          name: "#{user.first_name} #{user.last_name}",
          address: {
            city: user.addresses.last&.city,
            state: user.addresses.last&.state&.name,
            country: user.addresses.last&.country&.name,
            line1: user.addresses.last&.address1,
            line2: user.addresses.last&.address2,
            postal_code: user.addresses.last&.zipcode
          },
          metadata: { order_id: user.id }
        })
        user.update(stripe_customer_id: customer.id)
      end

      def create_or_retrieve_customer
        if user.stripe_customer_id.present?
          @customer  = Stripe::Customer.retrieve(user.stripe_customer_id)
        else
          @customer =  create_customer
        end
      end

      def create_payment_intent
        payment_method_id = params[:payment_method_id]
        payment_intent = Stripe::PaymentIntent.create(
          amount: (@booking.total_amount * 100).to_i,
          description: @booking.user.email,
          currency: params[:currency] || "usd",
          payment_method: payment_method_id,
          receipt_email: user.email,
          customer: @customer,
          confirm: false
        )
        if payment_intent.status == "requires_confirmation"
          payment_intent = confirm_payment_intent(payment_intent.id, payment_method_id)
        end      
      end

      def get_payment_intent
        Stripe::PaymentIntent.retrieve(@booking.payment_intent_id)
      end

      def attach_payment_method_to_customer(payment_method_token, customer_id)
        Stripe::PaymentMethod.attach(
          payment_method_token,{ customer: customer_id }
        )
      end

      def create_payment_method_from_token(token)
        payment_method = Stripe::PaymentMethod.create({
            type: "card",
            card: { token: token }  
        })
        
        attach_payment_method_to_customer( payment_method.id, current_devise_api_user.stripe_customer_id)
        payment_method.id
      end

      def confirm_payment_intent(payment_intent_id, payment_method_id)
        Stripe::PaymentIntent.confirm(
          payment_intent_id,
        {
            payment_method: payment_method_id,
            # return_url: params[redirect_url]
        })
      end
      
      def destroy_payment_method(payment_method_token)
        begin
          Stripe::PaymentMethod.detach(payment_method_token)
        rescue Stripe::InvalidRequestError => e
          raise "Failed to detach payment method: #{e.message}"
        end
      end
      
  end
end
