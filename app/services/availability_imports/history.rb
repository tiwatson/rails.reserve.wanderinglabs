class AvailabilityImports::History
  @queue = :other

  attr_accessor :import

  def self.perform(import_id)
    import = AvailabilityImport.find(import_id)
    new(import).create_history
  end

  def initialize(import)
    @import = import
  end

  def import_previous
    @_import_previous ||= AvailabilityImport.where('id < ?', import.id).where(facility_id: import.facility_id).last
  end

  def create_history
    import.history_open = history_exec(import.id, import_previous.id)
    import.history_filled = history_exec(import_previous.id, import.id)
    import.save
  end

  def history_exec(id1, id2)
    ActiveRecord::Base.connection.execute(history_sql(id1, id2)).to_a
  end

  def history_sql(id1, id2)
    <<-EOS
      select site_id, avail_date from availabilities where availability_import_id = #{id1}
      except
      select site_id, avail_date from availabilities where availability_import_id = #{id2}
    EOS
  end
end
