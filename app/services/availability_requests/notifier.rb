module AvailabilityRequests
  class Notifier
    attr_reader :availability_request

    def initialize(availability_request)
      @availability_request = availability_request
    end

    def needed?
      availability_request.availability_matches.available.notifiable.count.positive?
    end

    def notify
      return unless needed?
      availability_request.user.notification_methods.each do |nm|
        notify_for(nm)
        log_notify(nm)
      end
      mark_notified
      nil
    end

    private

    def mark_notified
      availability_request.availability_matches.available.notifiable.update_all(notified_at: Time.now)
    end

    def notify_for(nm)
      if nm.notification_type == :txt

      else
        NotifierMailer.new_availabilities(availability_request, nm).deliver
      end
    end

    def log_notify(nm)
      availability_request.availability_notifications.create(
        notification_method: nm,
        matches: availability_request.available_matches.count,
        matches_new: availability_request.available_matches.where(notified_at: nil).count
      )
    end
  end
end
