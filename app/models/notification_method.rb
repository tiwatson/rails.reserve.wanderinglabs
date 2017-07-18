class NotificationMethod < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :availability_notifications

  enumerize :notification_type, in: %i[email txt]
end
