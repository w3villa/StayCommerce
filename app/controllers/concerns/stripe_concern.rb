module StripeConcern

    def create_payment_method
        binding.pry
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
            email: current_devise_api_user.email,
            name: "#{current_devise_api_user.first_name} #{current_devise_api_user.last_name}",
            address: {
            city: current_devise_api_user.address.city,
            state: current_devise_api_user.address.state,
            country: current_devise_api_user.address.city,
            line1: current_devise_api_user.address.address1,
            line2: current_devise_api_user.address.address2,
            postal_code: current_devise_api_user.address.zipcode
        },
            metadata: { order_id: user.id }
        })
    end

    def create_or_retrieve_customer
        customers = Stripe::Customer.list(email: current_devise_api_user.email).data
        if customers.empty?
            create_customer
        else
            customers.first
        end
    end

    def create_payment_intent payment_method
        Stripe::PaymentIntent.create(
            amount: @booking.total_amount.to_i* 100,
            currency: params[:currency],
            description: 'Test payment',
            payment_method: payment_method,
            automatic_payment_methods: { enabled: true },
            receipt_email: current_devise_api_user.email,
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


# Stripe::Token.create({
#             card:{
#                 number: params[:card_number].to_s,
#                 exp_month: params[:exp_month],
#                 exp_year: params[:exp_year],
#                 cvc:params[:cvv]
#             }
#         })