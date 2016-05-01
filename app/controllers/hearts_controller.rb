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
        format.json { render :json => { hearts: dream.hearts.count, delete_heart_url: heart_path(heart) } }
      else
        format.json { render :json => { :status => 500, :message => heart.errors.full_messages.join(". ") + "." } }
      end
    end
  end

  def destroy
    respond_to do |format|
      heart = Heart.find(params[:id])
      dream = heart.dream
      heart.destroy
      format.json { render :json => { hearts: dream.hearts.count } }
    end
  end
end