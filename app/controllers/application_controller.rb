class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  helper_method :dream_types

  def authenticate_admin_user!
    unless current_user.try(:admin?)
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  def dream_types
    ["Personal", "Professional"]
  end

  def api_authenticated?
    if current_user.nil?
      respond_to do |format|
        message = "Please sign in first."
        format.json { render :json => { :status => 401, :message => message } }
        format.html do
          flash[:alert] = message
          redirect_to request.referrer || new_user_session_path
        end
      end
    end
  end

  def current_user
    if !params[:user_token].blank?
      return User.where(:authentication_token => params[:user_token]).first
    else
      super
    end   
  end

  protected

  def configure_devise_permitted_parameters
    registration_params = [:first_name, :last_name, :avatar, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password, :avatar)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end
end
