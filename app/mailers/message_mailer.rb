class MessageMailer < ActionMailer::Base
  include SendGrid
  sendgrid_enable :ganalytics, :opentrack
  helper :application # gives access to all helpers defined within `application_helper`.

  default from: '"Six Degrees Team" <contactsixdegrees@gmail.com>'

  def message_sent(message_id)
    @message = Message.find(message_id)
    @dream = @message.dream
    @sender = @message.user
    @receiver = @message.recipient
    @url = activities_url(@receiver)

    mail(from: "#{@sender.full_name} <#{@sender.email}>", to: "#{@receiver.full_name} <#{@receiver.email}>", subject: "#{@sender.full_name} messaged you about your dream")
  end
end