class AvailabilityMatchClick < ApplicationRecord
  extend Enumerize

  belongs_to :availability_match

  enumerize :from, in: %i[w e t]
  scope :available, (->{ where(available: true) })
end
