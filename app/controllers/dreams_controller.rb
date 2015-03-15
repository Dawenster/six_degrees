class DreamsController < ApplicationController
  def index
    respond_to do |format|
      dreams = Dream.dreams_with_user_info
      format.json { render :json => dreams }
    end
  end

  def show
    respond_to do |format|
      dream = Dream.find(params[:id])
      format.json { render :json => dream }
    end
  end

  def create
    respond_to do |format|
      dream = Dream.new(dream_params)
      if dream.save
        format.json { render :json => { :status => 200, :message => "dream created successfully", :dream => dream } }
      else
        format.json { render :json => { :status => 500, :message => dream.errors.full_messages.join(". ") + "." } }
      end
    end
  end

  def update
    respond_to do |format|
      dream = Dream.find(params[:id])
      dream.assign_attributes(dream_params)
      if dream.save
        format.json { render :json => { :status => 200, :message => "dream updated successfully", :dream => dream } }
      else
        format.json { render :json => { :status => 500, :message => dream.errors.full_messages.join(". ") + "." } }
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