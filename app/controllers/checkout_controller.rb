class CheckoutController < ApplicationController

    def new
        @stripe_checkout_session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            line_items: [{
                price: 'price_1MZuauECi1aTPXPYEtmpRxAI',
                quantity: 1
            }],
            mode: 'payment',
            success_url: checkout_success_url,
            cancel_url: checkout_cancel_url
        )
        # redirect_to session.url, allow_other_host: true
    end
    
    def create

        puts("CHEGOU AQUI ######################")
    
        redirect_to checkout_success_path
    end
    
    def success
        redirect_to root_path
    end
    
    def cancel
        # Add your custom logic for handling a canceled payment here
        # ...
    end
    
     private
    
    def checkout_success_url
        url_for(action: 'success', only_path: false)
    end
    
    def checkout_cancel_url
        url_for(action: 'cancel', only_path: false)
    end

end