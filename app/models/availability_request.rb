class AvailabilityRequest < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :facility
  has_many :availability_matches
  has_many :availability_notifications

  serialize :specific_site_ids, Array
  enumerize :site_type, in: %i[group tent_walk_in tent other rv rv_tent], predicates: { prefix: true }

  enumerize :status, in: %i[active paused canceled ended], predicates: { prefix: true }

  scope :active, (-> { where(status: :active).where('date_end > ?', Time.now.to_date) })

  after_create :welcome_email

  validates :stay_length, presence: true

  def available_matches(notified = false)
    availability_matches
      .send(notified ? 'notified' : 'notifiable')
      .available
      .includes(site: [:facility])
      .order('avail_date ASC')
  end

  def cache_site_ids
    self.site_ids = site_matcher.matching_site_ids
  end

  def site_matcher
    SiteMatcher.new(self)
  end

  def welcome_email
    user.notification_methods.each do |nm|
      next unless nm.notification_type == :email
      NotifierMailer.new_availability_request(self.reload, nm).deliver
    end
  end
end
