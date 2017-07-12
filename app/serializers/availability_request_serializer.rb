class AvailabilityRequestSerializer < ActiveModel::Serializer
  attributes :uuid, :user_id, :facility_id,
             :date_start, :date_end, :stay_length, :matches_availabile_count,
             :status, :checked_count, :checked_at

  belongs_to :facility

  def matches_availabile_count
    object.availability_matches.available.count
  end
end
