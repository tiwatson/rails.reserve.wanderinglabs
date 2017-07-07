module AvailabilityMatcher
  class Notify
    attr_reader :availability_request, :available_matches

    def initialize(availability_request, available_matches)
      @available_matches = available_matches
      @availability_request = availability_request
    end

    def needed?
      available_matches.where(notified_at: nil).count.positive?
    end

    def notify
      availability_request.notify
      available_matches.where(notified_at: nil).update_all(notified_at: Time.now)
    end
  end
end
