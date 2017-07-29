class PaymentsController < ApplicationController
  def create
    payment = Payments::Creator.new(params, current_user).create
    if payment.user # TODO: this is a security hole.
      render json: payment.user
    else
      render json: { id: payment.id }
    end
  end
end
