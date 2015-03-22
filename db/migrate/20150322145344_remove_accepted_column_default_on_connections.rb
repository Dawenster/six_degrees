class RemoveAcceptedColumnDefaultOnConnections < ActiveRecord::Migration
  def change
    change_column_default(:connections, :accepted, nil)
  end
end
