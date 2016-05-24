class ConnectionMailer < ActionMailer::Base
  include SendGrid
  sendgrid_enable :ganalytics, :opentrack
  helper :application # gives access to all helpers defined within `application_helper`.

  default from: '"Six Degrees Team" <contactsixdegrees@gmail.com>'

  def connection_made(connection_id)
    @connection = Connection.find(connection_id)
    @dream = @connection.dream
    @helper = @connection.user
    @receiver = @dream.user

    @url = activities_url(@helper)
    mail(from: @receiver.email, to: @helper.email, subject: "#{@receiver.first_name} accepted your offer to help")
  end
end