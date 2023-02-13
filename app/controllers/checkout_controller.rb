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
            success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: checkout_cancel_url
        )
        # redirect_to session.url, allow_other_host: true
    end
    
    def create
        redirect_to checkout_success_path
    end
    
    def success
        session_with_expand = Stripe::Checkout::Session.retrieve({ id: params[:session_id], expand: ["line_items"]})
        session_with_expand.line_items.data.each do |line_item| 
            product = Product.find_by(stripe_product_id: line_item.price.product)
            product.increment!(:sales_count)
        end
    end
    
    def cancel
    end
    
     private
    
    def checkout_success_url
        url_for(action: 'success', only_path: false, session_id: params[:session_id])
    end
    
    def checkout_cancel_url
        url_for(action: 'cancel', only_path: false)
    end

end