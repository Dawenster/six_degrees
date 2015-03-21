class DreamsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        dreams = Dream.dreams_with_user_info
        render :json => dreams
      end
      format.html do
        @dreams = Dream.all
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
      @dream.user_id = current_user.id
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
          flash[:notice] = "Dream successfully created."
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