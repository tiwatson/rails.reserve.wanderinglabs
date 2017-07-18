class AvailabilityImports::Index
  @queue = :import

  attr_reader :facility, :run_id, :hash

  def initialize(facility_id, run_id, hash)
    @facility = Facility.find(facility_id)
    @run_id = run_id
    @hash = hash
  end

  def perform
    if import_needed?
      import = AvailabilityImport.create(facility: facility, run_id: run_id)

      AvailabilityImports::FromJson.new(import).perform
      AvailabilityMatcher::Index.perform(import.reload)
    end

    update_facility
  end

  def import_needed?
    facility.last_import_hash != hash
  end

  def update_facility
    facility.last_import_hash = hash
    facility.last_import = Time.now
    facility.save
  end

  def self.perform(facility_id, import, hash)
    new(facility_id, import, hash).perform
  end
end
