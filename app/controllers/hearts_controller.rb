class HeartsController < ApplicationController
  before_filter :api_authenticated?
  skip_before_action :verify_authenticity_token

  def create
    respond_to do |format|
      dream = Dream.find(params[:dream_id])
      heart = Heart.new(
        dream: dream,
        user: current_user
      )

      if heart.save
        format.json { render :json => { hearts: dream.hearts.count } }
      else
        format.json { render :json => { :status => 500, :message => heart.errors.full_messages.join(". ") + "." } }
      end
    end
  end
end