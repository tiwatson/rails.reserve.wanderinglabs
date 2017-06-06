class Availability < ApplicationRecord
  belongs_to :facility
  belongs_to :site
end
