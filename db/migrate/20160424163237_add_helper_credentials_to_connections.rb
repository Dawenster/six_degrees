class AddHelperCredentialsToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :helper_credentials, :string
  end
end
