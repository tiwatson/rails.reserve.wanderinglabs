class AvailabilityImport < ApplicationRecord
  belongs_to :facility
  has_many :availabilities

end
