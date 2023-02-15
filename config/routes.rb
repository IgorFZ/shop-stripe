Rails.application.routes.draw do
  # DEVISE
  devise_for :users

  # OTHERS
  resources :products
  resources :webhooks, only: [:create]

  # CHECKOUT
  get 'checkout/new', to: 'checkout#new', as: 'new_checkout'
  post 'checkout', to: 'checkout#create', as: 'checkout'
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
  get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'

  # CART
  post "products/add_to_cart/:id", to: "products#add_to_cart", as: "add_to_cart"
  delete "products/remove_from_cart/:id", to: "products#remove_from_cart", as: "remove_from_cart"

  # ROOT
  root 'products#index'
end
