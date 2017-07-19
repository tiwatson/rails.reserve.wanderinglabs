module AvailabilityMatcher
  class Index
    attr_reader :availability_request, :import

    def initialize(import, availability_request)
      @import = import
      @availability_request = availability_request
    end

    def self.perform(import)
      facility = import.facility
      facility.availability_requests.active.each do |ar|
        new(import, ar).perform
      end
      nil
    end

    def perform
      mark_unavailable
      notify
      nil
    end

    def notify
      AvailabilityRequests::Notifier.new(availability_request).notify
    end

    def mark_unavailable
      AvailabilityMatcher::Unavailable.new(availability_request, available_matches.map(&:id)).mark
    end

    def available_matches
      @_available_matches ||= AvailabilityMatcher::Finder.new(import, availability_request).matching_availabilities
    end
  end
end
