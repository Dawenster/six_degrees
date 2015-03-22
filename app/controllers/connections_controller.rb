class ConnectionsController < ApplicationController
  def create
    respond_to do |format|
      begin
        @connection = Connection.new(connection_params)
        @connection.user_id = current_user.id
        if @connection.save
          ConnectionMailer.connection_offered(@connection.id).deliver

          connection_display = render_to_string(:partial => 'dreams/connection_offered.html.slim', :layout => false, :locals => { :dream => @connection.dream })

          format.json { render :json => { :status => 200, :message => "connection created successfully", :connection_display => connection_display } }
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
      rescue => error
        format.json { render :json => { :status => 500, :message => error } }
        format.html { render :json => { :status => 500, :message => error } }
      end
    end
  end

  def accept_connection
    respond_to do |format|
      begin
        connection = Connection.find(params[:id])
        connection.update_attributes(:accepted => true)
        ConnectionMailer.connection_made(connection.id).deliver
        format.json { render :json => { :status => 200, :message => "connection accepted successfully", :connection => connection } }
      rescue => error
        format.json { render :json => { :status => 500, :message => error } }
      end
    end
  end

  def decline_connection
    respond_to do |format|
      begin
        connection = Connection.find(params[:id])
        connection.update_attributes(:accepted => false)
        format.json { render :json => { :status => 200, :message => "connection declined successfully", :connection => connection } }
      rescue => error
        format.json { render :json => { :status => 500, :message => error } }
      end
    end
  end

  def email_display_as_string
    respond_to do |format|
      connection = Connection.find(params[:id])
      email_display = render_to_string(:partial => 'users/activities/display_email.html.slim', :layout => false, :locals => { :connection => connection })
      format.json { render :json => { :status => 200, :email_display => email_display } }
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