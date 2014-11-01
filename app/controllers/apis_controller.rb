class ApisController < ApplicationController
  def sign_in_via_facebook
    token = params[:facebook_token]
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
end