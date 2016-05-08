class SummariesController < ApplicationController

  before_action :authenticate_user!
  before_filter :check_for_valid_params, only: [:new]
  before_filter :check_current_user_can_edit_summary, only: [:edit]

  def new
    @summary = Summary.new
    @dream = Dream.find(params[:dream_id])
    @helper = User.find(params[:helper_id])
  end

  def create
    @summary = Summary.new(summary_params)
    @summary.user = current_user
    if @summary.save
      flash[:notice] = "Summary successfully created"
      redirect_to activities_path(current_user, anchor: "help-received")
    else
      @dream = @summary.dream
      @helper = @summary.helper
      flash[:alert] = @summary.errors.full_messages.join(". ") + "."
      render "new"
    end
  end

  def edit
    @summary = Summary.find(params[:id])
    @dream = @summary.dream
    @helper = @summary.helper
  end

  def update
    @summary = Summary.find(params[:id])
    @summary.assign_attributes(summary_params)
    if @summary.save
      flash[:notice] = "Summary successfully saved"
      redirect_to activities_path(current_user, anchor: "help-received")
    else
      @dream = @summary.dream
      @helper = @summary.helper
      flash[:alert] = @summary.errors.full_messages.join(". ") + "."
      render "new"
    end
  end

  def destroy
    summary = Summary.find(params[:id])
    summary.destroy
    flash[:notice] = "Summary successfully deleted"
    redirect_to activities_path(current_user, anchor: "help-received")
  end

  private 

  def summary_params
    params.require(:summary).permit(
      :dream_id,
      :user_id,
      :helper_id,
      :content
    )
  end

  def check_for_valid_params
    redirect_to root_path if params[:dream_id].blank?
  end

  def check_current_user_can_edit_summary
    redirect_to root_path unless Summary.find(params[:id]).user == current_user
  end
end