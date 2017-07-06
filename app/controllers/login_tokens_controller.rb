class LoginTokensController < ApplicationController
  skip_before_action :login_required, only: [:create]

  def create
    resource = User.where(email: params[:email]).first
    if resource
      # Resque.enqueue(SessionNew, resource.id)
      render json: { status: :success }
    else
      render json: { status: :not_found }, status: 404
    end
  end
end
