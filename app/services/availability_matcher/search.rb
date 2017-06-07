module AvailabilityMatcher
  class Search
    attr_reader :availability_request, :scrape

    def initialize(scrape, availability_request)
      @scrape = scrape
      @availability_request = availability_request
    end

    def search
      ActiveRecord::Base.connection.execute(matcher_sql)
    end

    def matcher_sql
      <<-EOS
        SELECT site_id, min("avail_date") as avail_min, max("avail_date"), count(avail_date) as length
        FROM (
            SELECT
              site_id,
              avail_date,
              "avail_date" - (dense_rank() over(order by "avail_date"))::int g
            FROM availabilities
            WHERE scrape = '#{scrape}' AND site_id IN (#{site_ids}) AND #{avail_date_sql}
        ) s
        group by s.g, s.site_id
        having count(avail_date) > #{availability_request.stay_length}
      EOS
    end

    def avail_date_sql
      ranges = availability_request.date_range.map do |date_range|
        "(avail_date >= '#{date_range[0]}' AND avail_date < '#{date_range[1]}')"
      end

      "( #{ranges.join(' OR ')} )"
    end

    def site_ids
      availability_request.site_ids.join(', ')
    end
  end
end
