class NotifierMailer < ApplicationMailer
  def new_availabilities(availability_request)
    @availability_request = availability_request
    mail(to: @availability_request.user.email, subject: "Campsite Available: #{@availability_request.facility.name}")
  end
end
