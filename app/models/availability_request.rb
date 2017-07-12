class AvailabilityRequest < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :facility
  has_many :availability_matches
  serialize :specific_site_ids, Array
  enumerize :site_type, in: %i[group tent_walk_in tent other rv rv_tent], predicates: { prefix: true }

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
    SiteMatcher.new(self)
  end

  def notify
    user.notification_methods.all.each do |nm|
      NotifierMailer.new_availabilities(self, nm).deliver
    end
  end
end
