class AddReferrerNameToReferrals < ActiveRecord::Migration
  def change
    add_column :referrals, :referrer_name, :string
  end
end
