class Stats
  @queue = :other
  def self.perform
    notifier = Slack::Notifier.new ENV['SLACK_HOOK'], channel: "#stats", username: "statBot"
    notifier.ping output
  end

  def self.output
    <<-EOS
AR: #{AvailabilityRequest.active.count} / #{AvailabilityRequest.where('created_at > ?', 1.day.ago).active.count}/ #{AvailabilityRequest.where('created_at > ?', 1.hour.ago).active.count}
AM: #{AvailabilityMatch.count} / #{AvailabilityMatch.where('created_at > ?', 1.day.ago).count}/ #{AvailabilityMatch.where('created_at > ?', 1.hour.ago).count}
AMC: #{AvailabilityMatchClick.count} / #{AvailabilityMatchClick.where('created_at > ?', 1.day.ago).count}/ #{AvailabilityMatchClick.where('created_at > ?', 1.hour.ago).count}
AMCA: #{AvailabilityMatchClick.available.count} / #{AvailabilityMatchClick.where('created_at > ?', 1.day.ago).available.count}/ #{AvailabilityMatchClick.where('created_at > ?', 1.hour.ago).available.count}
F: #{Facility.active_facilities.count}
    EOS
  end
end
