class LoginTokensController < ApplicationController
  def create
    resource = User.where(email: params[:email]).first
    if resource
      resource.generate_login_token
      NotifierMailer.user_token(resource).deliver
      render json: { status: :success }
    else
      render json: { status: :not_found }, status: 404
    end
  end
end
