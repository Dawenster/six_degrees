class ReferralMailer < ActionMailer::Base
  include SendGrid
  sendgrid_enable :ganalytics, :opentrack
  helper :application # gives access to all helpers defined within `application_helper`.

  default from: '"Six Degrees Team" <contactsixdegrees@gmail.com>'

  def referred(referral_id)
    @referral = Referral.find(referral_id)
    @dream = @referral.dream
    email = @referral.user.try(:email) || "contactsixdegrees@gmail.com"

    mail(from: "<#{email}>", to: "<#{@referral.email}>", subject: "#{@referral.referrer_name} referred you to help #{@dream.user.full_name}")
  end
end