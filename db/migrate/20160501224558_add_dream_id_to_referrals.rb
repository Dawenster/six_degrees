class AddDreamIdToReferrals < ActiveRecord::Migration
  def change
    add_column :referrals, :dream_id, :integer
  end
end
