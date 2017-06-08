class NotifierMailer < ApplicationMailer
  def new_availabilities(availability_request)
    @availability_request = availability_request
    mail(to: 'test@example.com', subject: "Campsite Available: #{@availability_request.facility.name}")
  end
end
