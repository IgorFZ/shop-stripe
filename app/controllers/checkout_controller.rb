class CheckoutController < ApplicationController

    def new
        @stripe_checkout_session = Stripe::Checkout::Session.create(
            customer: current_user.stripe_customer_id,
            payment_method_types: ['card'],
            line_items: [{
                price: params[:id],
                quantity: 1
            }],
            mode: 'payment',
            success_url: checkout_success_url,
            cancel_url: checkout_cancel_url
        )
    end
    
    def create
        redirect_to checkout_success_path
    end
    
    def success
    end
    
    def cancel
    end
    
     private
    
    def checkout_success_url
        url_for(action: 'success', only_path: false)
    end
    
    def checkout_cancel_url
        url_for(action: 'cancel', only_path: false)
    end

end