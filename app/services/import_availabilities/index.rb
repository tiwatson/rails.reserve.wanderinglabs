class ImportAvailabilities::Index
  # Checks previous import hash vs hash provided to see if import is actually required
  # If so.. import and kicks off Matcher service
  # Always calls service that updates checked_(count/at) for active availability requests

  @queue = :import

  attr_reader :facility, :import, :hash

  def initialize(facility_id, import, hash)
    @facility = Facility.find(facility_id)
    @import = import
    @hash = hash
  end

  def perform
    if import_needed?
      import
      AvailabilityMatcher::Index.perform(import, facility.id)
    end

    update_facility
  end

  def import
    # TODO: - OTHER PROVIDERS (or not.. depending on data)
    ImportAvailabilities::RecreationGov.new(facility.id, import).import
  end

  def import_needed?
    facility.last_import_hash != hash
  end

  def update_facility
    facility.last_import_hash = hash
    facility.last_import = Time.now
    facility.save

    Facilities::Checked.new(facility).mark_as
  end

  def self.perform(facility_id, import, hash)
    new(facility_id, import, hash).perform
  end
end
