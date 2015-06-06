class MessagesController < ApplicationController
  before_filter :api_authenticated?
  skip_before_action :verify_authenticity_token

  def create
    respond_to do |format|
      message = Message.new(
        :content => params[:content],
        :dream_id => params[:dream_id],
        :user_id => current_user.id
      )

      if message.save
        format.json { render :json => { :status => 200, :message => "message created successfully", :message => message } }
      else
        format.json { render :json => { :status => 500, :message => message.errors.full_messages.join(". ") + "." } }
      end
    end
  end
end