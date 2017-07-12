class User < ApplicationRecord
  has_many :notification_methods
  has_many :availability_requests

  def generate_auth_token
    token = SecureRandom.hex
    update_columns(auth_token: token)
    token
  end

  def invalidate_auth_token
    update_columns(auth_token: nil)
  end
end
