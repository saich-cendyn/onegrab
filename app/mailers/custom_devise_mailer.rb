# app/mailers/custom_devise_mailer.rb
class CustomDeviseMailer < Devise::Mailer
  helper :application
  default template_path: 'devise/mailer'
  default from: 'no-reply@onegrab.in'

  def confirmation_instructions(record, token, opts = {})
    @resource = record
    @confirmation_url = "#{ENV['FE_APP_URL']}/confirm?confirmation_token=#{token}"
    opts[:subject] = "Confirm your OneGrab account"

    mail(to: @resource.email, subject: opts[:subject]) do |format|
      format.html { render 'confirmation_instructions' }
    end
  end
end
