class Users::ActivitiesController < ApplicationController
  def index
    @user = User.find(params[:id])
    @dreams = @user.dreams
    @received = @user.dreams_with_connections
    @given = @user.connections
  end
end