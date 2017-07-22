class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :set_current_user
  # helper_method :person_signed_in?, :current_user

  def user_signed_in?
    current_user.present?
  end

  def login_required
    return true if user_signed_in?
    render json: { errors: [{ detail: 'Access denied' }] }, status: 401
  end

  def set_current_user
    current_user
    true
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
