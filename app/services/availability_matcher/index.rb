module AvailabilityMatcher
  class Index
    attr_reader :availability_request, :scrape

    def initialize(scrape, availability_request)
      @scrape = scrape
      @availability_request = availability_request
    end

    def self.perform(scrape, facility_id)
      facility = Facility.find(facility_id)
      facility.availability_requests.active.each do |ar|
        new(scrape, ar).perform
      end
      nil
    end

    def perform
      mark_unavailable
      notify.notify if notify.needed?
      nil
    end

    def notify
      @notify ||= AvailabilityMatcher::Notify.new(availability_request, available_matches)
    end

    def mark_unavailable
      AvailabilityMatcher::Unavailable.new(availability_request, available_matches.map(&:id)).mark
    end

    def available_matches
      @_available_matches ||= AvailabilityMatcher::Finder.new(scrape, availability_request).matching_availabilities
    end
  end
end
# am=AvailabilityMatcher::Index.new('test', AvailabilityRequest.last).perform
