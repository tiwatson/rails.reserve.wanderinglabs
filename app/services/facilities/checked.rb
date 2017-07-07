module Facilities
  class Checked
    @queue = :common

    attr_reader :facility

    def self.perform(facility_id)
      facility = Facility.find(facility_id)
      new(facility).mark_as
    end

    def initialize(facility)
      @facility = facility
    end

    def mark_as
      facility.availability_requests.active.update_all('checked_count = checked_count + 1, checked_at = NOW()')
    end
  end
end
