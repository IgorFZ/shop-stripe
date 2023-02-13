class Product < ApplicationRecord

    validates :name, :price, presence: true

    def to_s
        name
    end
    
    after_create do
        product = Stripe::Product.create(name: name)
        price_id = Stripe::Price.create({
            unit_amount: price,
            currency: 'brl',
            # recurring: {interval: 'once'},
            product: product.id,
        })
        update(stripe_price_id: price_id.id, stripe_product_id: product.id)
    end
end
