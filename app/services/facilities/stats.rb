module Facilities
  class Stats
    attr_reader :stay_length, :import_id

    def initialize(facility, stay_length)
      @import_id = facility.availability_imports.last.id
      @stay_length = stay_length
    end

    def search
      ActiveRecord::Base.connection.execute(matcher_sql).map(&:symbolize_keys)
    end

    private

    def matcher_sql
      <<-EOS
        SELECT site_id, MIN("avail_date") as avail_min, max("avail_date"), count(avail_date) as length
        FROM ( #{dense_rank_sql} ) s
        group by s.g, s.site_id
        having
          count(avail_date) >= '#{stay_length}'
      EOS
    end

    def dense_rank_sql
      <<-EOS
        SELECT
          site_id,
          avail_date,
          "avail_date" - (dense_rank() over(PARTITION BY site_id ORDER BY avail_date))::int g
        FROM availabilities
        WHERE
          availability_import_id = '#{import_id}'
      EOS
    end
  end
end
