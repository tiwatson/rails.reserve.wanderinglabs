class Payment < ApplicationRecord
  extend Enumerize

  belongs_to :user, optional: true

  enumerize :provider, in: %i[paypal], predicates: { prefix: true }
end
