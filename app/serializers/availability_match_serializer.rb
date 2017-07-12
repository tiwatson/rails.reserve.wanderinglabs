class AvailabilityMatchSerializer < ActiveModel::Serializer
  attributes :id, :avail_date, :length, :available, :unavailable_at, :notified_at, :short, :reserve_url
  belongs_to :site

  def short
    Base62.encode(object.id)
  end

  def reserve_url
    ReserveUrl.new(object).url
  end
end
