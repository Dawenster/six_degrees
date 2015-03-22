class Users::ActivitiesController < ApplicationController
  def index
    @dreams = current_user.dreams
    @received = current_user.dreams_with_connections
    @given = current_user.connections
  end
end