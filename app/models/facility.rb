class Facility < ApplicationRecord
  belongs_to :agency
  has_many :sites
end
