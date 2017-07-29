class User < ApplicationRecord
  has_many :notification_methods
  has_many :availability_requests
  has_many :payments

  validates :email, presence: true, uniqueness: true

  after_create :init_notification_method

  def mark_premium
    update_attributes(premium: true, premium_until: 1.year.from_now)
  end

  def generate_auth_token
    token = SecureRandom.hex
    update_columns(auth_token: token)
    token
  end

  def invalidate_auth_token
    update_columns(auth_token: nil)
  end

  def generate_login_token
    token = SecureRandom.hex
    update_attributes(login_token: token)
    token
  end

  def init_notification_method
    return if notification_methods.count.positive?
    notification_methods.create(notification_type: :email, param: email)
  end
end
