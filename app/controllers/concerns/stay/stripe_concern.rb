module Stay
    module StripeConcern
        extend ActiveSupport::Concern
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
                    cvc: params[:cvc],
                },
            })
        end
        def create_customer
            Stripe::Customer.create({
                email: user.email,
                name: "#{user.first_name} #{user.last_name}",
                address: {
                    city: user.addresses.last&.city,
                    state: user.addresses.last&.state.name,
                    country: user.addresses.last&.country.name,
                    line1: user.addresses.last&.address1,
                    line2: user.addresses.last&.address2,
                    postal_code: user.addresses.last&.zipcode
                },
                metadata: { order_id: user.id }
            })
        end

        def create_or_retrieve_customer
            customers = Stripe::Customer.list(email: user.email).data
            if customers.empty?
                create_customer
            else
                customers.first
            end
        end

        def create_payment_intent 
            Stripe::PaymentIntent.create(
                amount: @booking.total.to_i* 100,
                description: @booking.user.email,
                currency: params[:currency] || 'INR',
                payment_method: params[:payment_method_id],
                automatic_payment_methods: { enabled: true },
                receipt_email: user.email,
                customer: @customer,
                confirm: params[:confirm],
                return_url: params[:redirect_url]
            )
        end
        
        def get_payment_intent
            Stripe::PaymentIntent.retrieve(@booking.payment_intent_id)
        end

        def confirm_payment_intent
            Stripe::PaymentIntent.confirm(
            params[:payment_intent_id],
            {
                payment_method: params[:payment_method_id], 
                return_url: params[redirect_url],
            })
        end    
                        
    end
end