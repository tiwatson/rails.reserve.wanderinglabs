class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  # before_action :login_required
  # helper_method :person_signed_in?, :current_user

  def user_signed_in?
    current_person.present?
  end

  def login_required
    return true if authenticate_token
    render json: { errors: [{ detail: 'Access denied' }] }, status: 401
  end

  def current_user
    @_current_user ||= authenticate_token
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      User.find_by(auth_token: token)
    end
  end
end
