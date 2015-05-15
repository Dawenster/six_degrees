class DreamsController < ApplicationController
  # before_filter :authenticate_user!, :except => [:index, :show]
  skip_before_action :verify_authenticity_token
  
  def index
    respond_to do |format|
      format.json do
        dreams = Dream.dreams_with_user_info
        render :json => dreams
      end
      format.html do
        @dreams = Dream.all.shuffle
        render "index"
      end
    end
  end

  def show
    respond_to do |format|
      dream = Dream.find(params[:id])
      format.json { render :json => dream }
    end
  end

  def new
    @dream = Dream.new
  end

  def create
    respond_to do |format|
      @dream = Dream.new(dream_params)
      @dream.user_id = current_user ? current_user.id : params[:dream][:user_id]
      if @dream.save
        format.json { render :json => { :status => 200, :message => "dream created successfully", :dream => @dream } }
        format.html do
          flash[:notice] = "Dream successfully created."
          redirect_to dreams_path
        end
      else
        dream_errors = @dream.errors.full_messages.join(". ") + "."
        format.json { render :json => { :status => 500, :message => dream_errors } }
        format.html do
          flash.now[:alert] = dream_errors
          render "new"
        end
      end
    end
  end

  def edit
    @dream = Dream.find(params[:id])
  end

  def update
    respond_to do |format|
      @dream = Dream.find(params[:id])
      @dream.assign_attributes(dream_params)
      if @dream.save
        format.json { render :json => { :status => 200, :message => "dream updated successfully", :dream => @dream } }
        format.html do
          flash[:notice] = "Dream successfully updated."
          redirect_to dreams_path
        end
      else
        dream_errors = @dream.errors.full_messages.join(". ") + "."
        format.json { render :json => { :status => 500, :message => dream_errors } }
        format.html do
          flash.now[:alert] = dream_errors
          render "edit"
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      dream = Dream.find(params[:id])
      dream.destroy
      format.json { render :json => { :status => 200, :message => "dream destroyed successfully", :dream => dream } }
    end
  end

  def connection_offered_as_string
    respond_to do |format|
      dream = Dream.find(params[:id])
      connection_offered_display = render_to_string(:partial => 'dreams/connection_offered.html.slim', :layout => false, :locals => { :dream => dream })
      format.json { render :json => { :status => 200, :connection_offered_display => connection_offered_display } }
    end
  end

  private 

  def dream_params
    params.require(:dream).permit(
      :description,
      :dream_type,
      :created_at,
      :updated_at,
      :user_id,
      :_destroy
    )
  end

end