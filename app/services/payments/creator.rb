class Payments::Creator
  attr_reader :params, :current_user
  def initialize(params, current_user = nil)
    @params = params
    @current_user = current_user
  end

  def user
    current_user || User.where(email: paypal_payment.payer.payer_info.email).first
  end

  def create
    payment = Payment.new(payment_params)
    if payment.save
      user&.mark_premium
    else
      Rails.logger.fatal("CREATE PAYMENT: #{payment.to_json}")
    end
    payment
  end

  def payment_params
    {
      user: user,
      provider: :paypal,
      status: paypal_payment.state,
      total: paypal_payment.transactions[0].amount.total,
      email: paypal_payment.payer.payer_info.email,
      params: params,
      details: paypal_payment.to_hash,
      paid_at: Time.now,
    }
  end

  def paypal_payment
    @_paypal ||= PayPal::SDK::REST::Payment.find(params[:payment][:details][:paymentID])
  end
end
