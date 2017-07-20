class NotifierMailer < ApplicationMailer
  def new_availabilities(availability_request, notification_method)
    @availability_request = availability_request
    mail(to: notification_method.param, subject: "Campsite Available: #{@availability_request.facility.name}")
  end

  def new_availability_request(availability_request, notification_method)
    @availability_request = availability_request
    mail(to: notification_method.param, subject: "Campsite Availability Request Confirmed: #{@availability_request.facility.name}")
  end

  def user_token(user)
    @user = user
    mail(to: user.email, subject: 'WanderingLabs user token')
  end
end
