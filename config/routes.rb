Rails.application.routes.draw do

  get 'checkouts' => 'checkouts#payments'
  get 'checkout/confirmation', :to => 'checkouts#confirmation'
  post 'checkout/confirmation', :to => 'checkouts#details'
  get 'checkout/error', :to => 'checkouts#error'


  resource :checkout
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
