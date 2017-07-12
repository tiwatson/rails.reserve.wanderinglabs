class NotificationMethod < ApplicationRecord
  belongs_to :user
  has_many :availability_notifications
end
