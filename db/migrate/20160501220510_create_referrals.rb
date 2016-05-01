class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :email
      t.integer :user_id

      t.timestamps
    end
  end
end
