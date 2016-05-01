class MessagesController < ApplicationController
  before_filter :api_authenticated?
  skip_before_action :verify_authenticity_token

  def create
    respond_to do |format|
      dream = Dream.find(params[:dream_id])

      message = Message.new(
        :content => params[:content],
        :dream_id => dream.id,
        :user_id => current_user.id,
        :recipient_id => params[:recipient_id]
      )

      if message.save
        unless dream.helped_by(current_user) || dream.user == current_user
          connection = Connection.create(
            dream_id: dream.id,
            user_id: current_user.id,
            helper_credentials: params[:credentials]
          )
          connection_html = put_html_around_connection(connection)
        end
        MessageMailer.delay.message_sent(message.id).deliver if message.recipient.message_notification
        format.json {
          render :json => {
            :status => 200,
            :message => "message created successfully",
            :message => message,
            :message_with_html => put_html_around_message(message),
            :connection_with_html => connection_html
          }
        }
      else
        format.json { render :json => { :status => 500, :message => message.errors.full_messages.join(". ") + "." } }
      end
    end
  end

  private

  def put_html_around_message(message)
    render_to_string(partial: 'dreams/message.html.slim', locals: { message: message, :user => message.user }, :layout => false)
  end

  def put_html_around_connection(connection)
    render_to_string(partial: 'connections/other_helper.html.slim', locals: { connection: connection }, :layout => false)
  end
end