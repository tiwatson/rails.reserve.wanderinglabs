class Facility < ApplicationRecord
  belongs_to :agency
  has_many :sites
  has_many :availability_requests
end
