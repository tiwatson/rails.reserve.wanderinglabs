module AvailabilityMatcher
  class Notify
    attr_reader :availability_request, :available_matches

    def initialize(availability_request, available_matches)
      @available_matches = available_matches
      @availability_request = availability_request
    end

    def needed?
      available_matches.select { |a| a.notified_at.nil? }.size.positive?
    end

    def notify
      puts 'YUP..notify'
    end
  end
end
