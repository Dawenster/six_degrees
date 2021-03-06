class RegistrationMailer < Devise::Mailer
  include SendGrid
  sendgrid_enable :ganalytics, :opentrack
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default from: '"Six Degrees Team" <contactsixdegrees@gmail.com>'

  def confirmation_instructions(resource, token, opts={})
    opts[:subject] = "Confirm your Six Degrees account"
    @name = resource.first_name
    @name ||= resource.email
    super
  end

  def reset_password_instructions(resource, token, opts={})
    opts[:subject] = "Confirm your Six Degrees account"
    @name = resource.first_name
    @name ||= resource.email
    super
  end

  def unlock_instructions(resource, token, opts={})
    opts[:subject] = "Confirm your Six Degrees account"
    @name = resource.first_name
    @name ||= resource.email
    super
  end
end