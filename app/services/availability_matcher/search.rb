module AvailabilityMatcher
  class Search
    attr_reader :availability_request, :import_id

    def initialize(availability_request, import_id)
      @import_id = import_id
      @availability_request = availability_request
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
          count(avail_date) >= '#{availability_request.stay_length}' AND
          min(avail_date) <= '#{availability_request.date_end}'
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
          availability_import_id = '#{import_id}' AND
          site_id IN(#{site_ids}) AND
          avail_date >= '#{availability_request.date_start}'
          #{arrival_days_sql}
      EOS
    end

    def arrival_days_sql
      return nil if availability_request.arrival_days.nil? || availability_request.arrival_days.empty?
      "AND EXTRACT(dow from avail_date::DATE) IN(#{availability_request.arrival_days.join(', ')})"
    end

    # def avail_date_sql
    #   ranges = availability_request.date_range.map do |date_range|
    #     "(avail_date >= '#{date_range[0]}' AND avail_date <= '#{date_range[1]}')"
    #   end

    #   "( #{ranges.join(' OR ')} )"
    # end

    def site_ids
      availability_request.site_ids.join(', ')
    end
  end
end
