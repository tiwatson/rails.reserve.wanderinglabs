module AvailabilityMatcher
  class Finder
    attr_reader :availability_request, :import

    def initialize(import, availability_request)
      @import = import
      @availability_request = availability_request
    end

    def matching_availabilities
      search.map do |matched_avail|
        availability_match = AvailabilityMatch.find_or_initialize_by(
          availability_request_id: availability_request.id,
          site_id: matched_avail[:site_id],
          length: matched_avail[:length],
          avail_date: matched_avail[:avail_min],
          available: true
        )
        availability_match.save
        availability_match
      end
    end

    def search
      AvailabilityMatcher::Search.new(availability_request, import.id).search
    end
  end
end
