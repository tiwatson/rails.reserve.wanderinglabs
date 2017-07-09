class AvailabilityRequestSerializer < ActiveModel::Serializer
  attributes :uuid, :user_id, :facility_id, :date_start, :date_end
  belongs_to :facility
end
