class SessionsController < ApplicationController
  before_action :login_required, only: [:destroy]

  def create
    resource = User.where(login_token: params[:token]).first

    if resource
      auth_token = resource.generate_auth_token
      render json: { auth_token: auth_token, user: resource }
    else
      invalid_login_attempt
    end
  end

  def destroy
    resource = current_person
    resource.invalidate_auth_token
    head :ok
  end

  private

  def invalid_login_attempt
    render json: { errors: [{ detail: 'Error with your login or password' }] }, status: 401
  end
end
