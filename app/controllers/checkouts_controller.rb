require 'json'

class CheckoutsController < ApplicationController


  def payments
    payment_methods_response = Checkout.get_payment_methods.body

    @resp = payment_methods_response

  end

  def create

    payment_response = Checkout.make_payment(params["paymentMethod"])

    payment_response_hash = JSON.parse(payment_response.body)

    result_code = payment_response_hash["resultCode"]
    action = payment_response_hash["action"]
    paymentMethodType = params["paymentMethod"]["type"]

    case result_code
      when "Authorised"
        redirect_to '/checkout/confirmation'
      when "RedirectShopper"
        if paymentMethodType == "ideal"
          redirect_to payment_response_hash["redirect"]["url"]
        end

        if paymentMethodType == "scheme"

          session[:payment_data] = payment_response_hash["paymentData"]
          render json: action
        end
      when "Error"
        # Generic error page
        redirect_to '/checkout/error'
      else
        # Handle other payment result codes
    end
  end

  def confirmation
  end

  def error
  end


  def details
    payload = {}
    details = {}
    details["MD"] = params["MD"]
    details["PaRes"] = params["PaRes"]
    payload["details"] = details
    payload["paymentData"] = session[:payment_data]

    resp = Checkout.submit_details(payload)
    resp_hash = JSON.parse(resp.body)

    session[:payment_data] = ""

    if resp_hash["resultCode"] == "Authorised"
      redirect_to '/checkout/confirmation'
    else
      redirect_to '/checkout/error'
    end
  end
end
