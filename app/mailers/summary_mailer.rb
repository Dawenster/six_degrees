class SummaryMailer < ActionMailer::Base
  include SendGrid
  sendgrid_enable :ganalytics, :opentrack
  helper :application # gives access to all helpers defined within `application_helper`.

  default from: '"Six Degrees Team" <contactsixdegrees@gmail.com>'

  def write_summary(dreamer_id, dream_id, helper_id)
    @dreamer = User.find(dreamer_id)
    @dream = Dream.find(dream_id)
    @helper = User.find(helper_id)

    mail(to: "#{@dreamer.full_name} <#{@dreamer.email}>", subject: "Write about how #{@helper.full_name} helped you")
  end
end