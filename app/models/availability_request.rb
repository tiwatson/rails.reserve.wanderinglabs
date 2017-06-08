class AvailabilityRequest < ApplicationRecord
  belongs_to :user
  belongs_to :facility
  has_many :availability_matches

  scope :active, (-> { where('date_end > ?', Time.now.to_date) })

  def available_matches(notified = false)
    availability_matches
      .send(notified ? 'notified' : 'notifiable')
      .available
      .includes(:site)
      .order('avail_date ASC')
  end

  def date_range
    [
      [date_start, date_end]
    ]

    # TODO: weekends
    # if weekends?
    #   date_sert.to(date_end).map do |day|
    #     [weekend_start, weekend_end]
    #   end
    # end
  end

  def cache_site_ids
    self.site_ids = site_matcher.matching_site_ids
  end

  def site_matcher
    SiteMatcher::RecreationGov.new(facility.id, details)
  end

  def notify
    NotifierMailer.new_availabilities(self).deliver
  end
end
