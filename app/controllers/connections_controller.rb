class ConnectionsController < ApplicationController
  def index
    @dreams = current_user.dreams_with_connections
  end

  def create
    respond_to do |format|
      @connection = Connection.new(connection_params)
      @connection.user_id = current_user.id
      if @connection.save
        format.json { render :json => { :status => 200, :message => "connection created successfully", :connection => @connection } }
        format.html do
          flash[:notice] = "Help successfully offered!"
          redirect_to dreams_path
        end
      else
        connection_errors = @connection.errors.full_messages.join(". ") + "."
        format.json { render :json => { :status => 500, :message => connection_errors } }
        format.html do
          flash[:alert] = connection_errors
          redirect_to dreams_path
        end
      end
    end
  end

  private 

  def connection_params
    params.require(:connection).permit(
      :initial_message,
      :accepted,
      :dream_id,
      :user_id,
      :created_at,
      :updated_at,
      :_destroy
    )
  end
end