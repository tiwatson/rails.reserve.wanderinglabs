module AvailabilityMatcher
  class Index
    attr_reader :availability_request, :import

    def initialize(import, availability_request)
      @import = import
      @availability_request = availability_request
    end

    def self.perform(import, facility_id)
      facility = Facility.find(facility_id)
      facility.availability_requests.active.each do |ar|
        new(import, ar).perform
      end
      nil
    end

    def perform
      mark_unavailable
      notify.notify if notify.needed?
      nil
    end

    def notify
      @_notify ||= AvailabilityMatcher::Notify.new(availability_request) # , available_matches)
    end

    def mark_unavailable
      AvailabilityMatcher::Unavailable.new(availability_request, available_matches.map(&:id)).mark
    end

    def available_matches
      @_available_matches ||= AvailabilityMatcher::Finder.new(import, availability_request).matching_availabilities
    end
  end
end
# am=AvailabilityMatcher::Index.new('test', AvailabilityRequest.last).perform
