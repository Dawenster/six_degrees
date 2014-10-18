class ApisController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_filter :allow_cors

  def sign_in_via_facebook
    token = params[:access_token]
    permissions = "id,name,picture.type(large),email,first_name,last_name,gender,timezone"
    params_to_send = {
      :fields => permissions,
      :access_token => token
    }
    results = JSON.parse(RestClient.get "https://graph.facebook.com/me", { :params => params_to_send })

    user = User.find_by_uid(results["id"])
    user = User.create_user(results) unless user

    user_data = user.as_json
    user_data["authentication_token"] = user.authentication_token

    respond_to do |format|
      format.json { render :json => user_data }
    end
  end

  private

  def allow_cors
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
    headers["Access-Control-Allow-Headers"] =
      %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")

    head(:ok) if request.request_method == "OPTIONS"
  end
end