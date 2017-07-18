Rails.application.config.middleware.use(
  ExceptionNotification::Rack,
  slack: {
    webhook_url: ENV['SLACK_HOOK'],
    channel: '#exceptions',
  }
)
