class Sns
  require 'aws-sdk'

  def self.publish(message)
    sns = Aws::SNS::Resource.new
    topic = sns.topic(ENV['AWS_SNS_SCRAPER'])
    topic.publish(
      subject: 'Test Subject',
      message: message.to_json
    )
  end
end
