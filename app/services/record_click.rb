class RecordClick < Struct.new(:availability_match, :from)
  def perform
    AvailabilityMatchClick.create(attributes_for_create)
  end

  def attributes_for_create
    {
      availability_match: availability_match,
      from: from,
      available: availability_match.available,
      elapsed_time: Time.now - (AvailabilityNotification.last&.created_at || Time.now),
    }
  end
end
