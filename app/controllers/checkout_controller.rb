class CheckoutController < ApplicationController
    before_action :load_cart

    def new
        @stripe_checkout_session = Stripe::Checkout::Session.create(
            customer: current_user.stripe_customer_id,
            payment_method_types: ['card'],
            allow_promotion_codes: true,
            line_items: @cart.collect { |item| item.to_builder.attributes! },
            mode: 'payment',
            success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url: checkout_cancel_url
        )
    end
    
    def create
        redirect_to checkout_success_path
    end
    
    def success
        @session_with_expand = Stripe::Checkout::Session.retrieve({id: params[:session_id], expand: ["line_items"]})
        @session_with_expand.line_items.data.each do |line_item|
            product = Product.find_by(stripe_product_id: line_item.price.product)
        end
    end
    
    def cancel
    end
    
     private
    
    def checkout_success_url
        session[:cart] = []
        url_for(action: 'success', only_path: false, session_id: params[:session_id])
    end
    
    def checkout_cancel_url
        url_for(action: 'cancel', only_path: false)
    end

    def load_cart
        @cart = Product.find(session[:cart])
    end

end