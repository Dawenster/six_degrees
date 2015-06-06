class AddMessageNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :message_notification, :boolean, :default => true
  end
end
