Rails.application.routes.draw do
  devise_for :users
  resources :products
  resources :webhooks, only: [:create]

  get 'checkout/new', to: 'checkout#new', as: 'new_checkout'
  post 'checkout', to: 'checkout#create', as: 'checkout'
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
  get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'

  root 'products#index'
end
