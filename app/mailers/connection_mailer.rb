class ConnectionMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.

  default from: '"Six Degrees Team" <contactsixdegrees@gmail.com>'

  def connection_offered(connection_id)
    @connection = Connection.find(connection_id)
    @dream = @connection.dream
    @helper = @connection.user
    @receiver = @dream.user

    @url = activities_url(@receiver)
    mail(from: "contactsixdegrees@gmail.com", to: @receiver.email, subject: "#{@helper.first_name} wants to help with your dream")
  end

  def connection_made(connection_id)
    @connection = Connection.find(connection_id)
    @dream = @connection.dream
    @helper = @connection.user
    @receiver = @dream.user

    @url = activities_url(@helper)
    mail(from: @receiver.email, to: @helper.email, subject: "#{@receiver.first_name} accepted your offer to help")
  end
end