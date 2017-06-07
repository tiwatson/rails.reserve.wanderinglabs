class AvailabilityMatcher
  attr_reader :availability_request, :scrape

  def initialize(scrape, availability_request)
    @scrape = scrape
    @availability_request = availability_request
  end

  def perform
    available_matches = create_matching_availabilities
    no_longer_avail = availability_request.availability_matches
                                          .where(available: true)
                                          .where('id NOT IN (?)', available_matches.map(&:id))
    puts "NO LONGER - #{no_longer_avail.count}"
    no_longer_avail.update_all(available: false, unavailable_at: Time.now)

    needs_notified = available_matches.select { |a| a.notified_at.nil? }.size.positive?

    puts "needs_notified #{needs_notified}"
  end

  def create_matching_availabilities
    matching_availabilities.map do |matched_avail|
      am = AvailabilityMatch.find_or_initialize_by(
        availability_request_id: availability_request.id,
        site_id: matched_avail['site_id'],
        length: matched_avail['length'],
        avail_date: matched_avail['avail_min'],
        available: true
      )
      am.save
      puts am.errors.to_json
      am
    end
  end

  def matching_availabilities
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
