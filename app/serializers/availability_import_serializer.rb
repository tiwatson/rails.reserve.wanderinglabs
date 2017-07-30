class AvailabilityImportSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :date_start, :date_end, :history_open_count, :history_filled_count

  belongs_to :facility

  def history_open_count
    object.history_open&.size || 0
  end
  def history_filled_count
    object.history_filled&.size || 0
  end
end
