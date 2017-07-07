module AvailabilityMatcher
  class Notify
    attr_reader :availability_request

    def initialize(availability_request)
      @availability_request = availability_request
    end

    def needed?
      availability_request.available_matches.where(notified_at: nil).count.positive?
    end

    def notify
      return unless needed?
      availability_request.notify
      availability_request.available_matches.where(notified_at: nil).update_all(notified_at: Time.now)
    end
  end
end
