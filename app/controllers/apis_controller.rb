class ApisController < ApplicationController
  skip_before_action :verify_authenticity_token

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

  def mobile_create_user
    respond_to do |format|
      if params[:facebook_id].present?
        user = User.create_user(params)
      else
        user = User.new
        user.email = params[:email]
        user.password = params[:password]
        user.first_name = params[:first_name]
        user.last_name = params[:last_name]
        user.encrypted_password
        user.skip_confirmation!
      end
      if user.save
        format.json { render :json => { :status => 200, :message => "User successfully created!", :user => user } }
      else
        format.json { render :json => { :status => 400, :message => user.errors.full_messages.join(". ") + "." } }
      end
    end
  end
end