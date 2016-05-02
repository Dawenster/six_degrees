class CreateKudos < ActiveRecord::Migration
  def change
    create_table :kudos do |t|
      t.integer :giver_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
