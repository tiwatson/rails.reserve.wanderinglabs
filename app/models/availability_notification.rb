class AvailabilityNotification < ApplicationRecord
  belongs_to :availability_request
  belongs_to :notification_method
end
