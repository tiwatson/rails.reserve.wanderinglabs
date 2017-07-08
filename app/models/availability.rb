class Availability < ApplicationRecord
  belongs_to :availability_import
  belongs_to :site
end
