class KudosController < ApplicationController
  before_filter :api_authenticated?
  skip_before_action :verify_authenticity_token

  def create
    respond_to do |format|
      kudo = Kudo.new(
        giver_id: params[:giver_id],
        receiver_id: params[:receiver_id]
      )

      if kudo.save
        format.json { render :json => { hearts: kudo.receiver.received_kudos.count } }
      else
        format.json { render :json => { :status => 500, :message => kudo.errors.full_messages.join(". ") + "." } }
      end
    end
  end

end