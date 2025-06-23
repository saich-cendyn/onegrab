class UserMailer < ApplicationMailer
  default from: 'no-reply@onegrab.in'

  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm your OneGrab account')
  end
end
