class MessageMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.

  default from: '"Six Degrees Team" <contactsixdegrees@gmail.com>'

  def message_sent(message_id)
    @message = Message.find(message_id)
    @dream = @message.dream
    @helper = @message.user
    @receiver = @dream.user
    @url = activities_url(@receiver)

    mail(from: "#{@helper.full_name} <#{@helper.email}>", to: "#{@receiver.full_name} <#{@receiver.email}>", subject: "#{@helper.full_name} messaged you about your dream")
  end
end