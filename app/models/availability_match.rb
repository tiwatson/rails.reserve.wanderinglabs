class AvailabilityMatch < ApplicationRecord
  belongs_to :availability_request
  belongs_to :site

  scope :available, (-> { where(available: true) })
  scope :not_in_list, (->(ids) { where('id NOT IN (?)', ids) })
  scope :notifiable, (-> { where(notified_at: nil) })
  scope :notified, (-> { where.not(notified_at: nil) })

  def self.find_by_base62(base62)
    id = Base62.decode(base62)
    find(id)
  end
end
