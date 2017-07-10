class AvailabilityMatchSerializer < ActiveModel::Serializer
  attributes :id, :avail_date, :length, :available, :unavailable_at, :notified_at
  belongs_to :site
end
