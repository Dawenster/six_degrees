class DreamsController < ApplicationController
  def index
    respond_to do |format|
      dreams = Dream.dreams_with_user_info
      format.json { render :json => dreams }
    end
  end
end