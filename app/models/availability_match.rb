class AvailabilityMatch < ApplicationRecord
  belongs_to :availability_request
  belongs_to :site
end
