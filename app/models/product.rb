class Product < ApplicationRecord

    validates :name, :price, presence: true

    def to_s
        name
    end
    
    after_create do
        product = Stripe::Product.create(name: name)
        product_price = Stripe::Price.create({
            unit_amount: price,
            currency: 'brl',
            # recurring: {interval: 'once'},
            product: product.id,
        })
        update(stripe_price_id: product_price.id, stripe_product_id: product.id)
    end

    after_update :create_and_assign_new_stripe_price, if: :saved_change_to_price?
    def create_and_assign_new_stripe_price
        price = Stripe::Price.create(product: self.stripe_product_id, unit_amount: self.price, currency: "usd")
        update(stripe_price_id: price.id)
    end

    def to_builder
        Jbuilder.new do |product|
            product.price stripe_price_id
            product.quantity 1
        end
    end
end
