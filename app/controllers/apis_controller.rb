class ApisController < ApplicationController
  before_filter :api_authenticated?, :only => [:logout_user]
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

  def user
    respond_to do |format|
      if current_user.nil?
        format.json { render :json => { :status => 400, :message => "User not found with that authentication_token..." } }
      else
        format.json { render :json => { :status => 200, :message => "User found!", :user => current_user, :small_avatar => current_user.small_avatar, :large_avatar => current_user.large_avatar } }
      end
    end
  end

  def create_user
    respond_to do |format|
      if params[:uid].present?
        params[:id] = params[:uid]
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

  def login_user
    respond_to do |format|
      if params[:uid].present?
        user = User.find_by_uid(params[:uid])
        if user.present?
          user.save
          format.json { render :json => { :status => 200, :message => "User logged in successfully!", :user => user } }
        else
          format.json { render :json => { :status => 400, :message => "User with ID #{params[:uid]} not found" } }
        end
      else
        user = User.find_by_email(params[:email])
        if user && user.valid_password?(params[:password])
          user.save
          format.json { render :json => { :status => 200, :message => "User logged in successfully!", :user => user } }
        else
          format.json { render :json => { :status => 400, :message => "Wrong email or password." } }
        end
      end
    end
  end

  def logout_user
    respond_to do |format|
      current_user.update_attributes(:authentication_token => nil)
      format.json { render :json => { :status => 200, :message => "User logged out successfully!" } }
    end
  end

  def dreams_helped_by_user
    respond_to do |format|
      if current_user
        dreams_with_messages = current_user.connections.map { |connection| connection.dream }
        if dreams_with_messages.any?
          format.json { render :json => { :status => 200, :message => "successful fetch of dreams", :dreams => dreams_with_messages } }
        else
          format.json { render :json => { :status => 200, :message => "has not helped anyone yet" } }
        end
      else
        format.json { render :json => { :status => 500, :message => "no user found" } }
      end
    end
  end
end