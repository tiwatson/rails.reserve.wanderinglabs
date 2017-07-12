class NotifierMailer < ApplicationMailer
  def new_availabilities(availability_request, notification_method)
    @availability_request = availability_request
    mail(to: notification_method.param, subject: "Campsite Available: #{@availability_request.facility.name}")
  end
end
