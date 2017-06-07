class User < ApplicationRecord
  has_many :availability_requests
end
