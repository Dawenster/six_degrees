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
        Connection.create(:dream_id => dream.id, :user_id => current_user.id) unless dream.helped_by(current_user) || dream.user == current_user
        MessageMailer.message_sent(message.id).deliver if message.recipient.message_notification
        format.json { render :json => { :status => 200, :message => "message created successfully", :message => message, :message_with_html => put_html_around(message) } }
      else
        format.json { render :json => { :status => 500, :message => message.errors.full_messages.join(". ") + "." } }
      end
    end
  end

  private

  def put_html_around(message)
    render_to_string(partial: 'messages/single.html.slim', locals: { message: message, :user => message.user }, :layout => false)
  end
end