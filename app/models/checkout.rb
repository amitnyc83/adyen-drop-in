require 'adyen-ruby-api-library'

class Checkout < ApplicationRecord

  def self.get_payment_methods
    adyen = Adyen::Client.new
    adyen.api_key = ENV["API_KEY"]
    adyen.env = :test

    response = adyen.checkout.payment_methods({
      :merchantAccount => ENV["MERCHANT_ACCOUNT"],
      :countryCode => 'NL',
      :amount => {
        :currency => 'EUR',
        :value => 1000
      },
      :channel => 'Web'
    })

    response
  end


  def self.make_payment(payment_method)
    adyen = Adyen::Client.new
    adyen.api_key = ENV["API_KEY"]
    adyen.env = :test

    response = adyen.checkout.payments({
      :amount => {
        :currency => "EUR",
        :value => 1000
      },
      :channel => "Web",
      :reference => "12345",
      :paymentMethod => payment_method,
      :returnUrl => "http://localhost:3000/checkout/confirmation",
      :merchantAccount => ENV["MERCHANT_ACCOUNT"]
    })

    response
  end


  def self.submit_details(details)
    adyen = Adyen::Client.new
    adyen.api_key = ENV["API_KEY"]
    adyen.env = :test

    response = adyen.checkout.payments.details(details)

    response
  end
end
