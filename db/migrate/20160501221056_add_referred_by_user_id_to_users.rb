class AddReferredByUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referred_by_user_id, :integer
  end
end
