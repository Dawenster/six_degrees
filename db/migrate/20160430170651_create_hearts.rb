class CreateHearts < ActiveRecord::Migration
  def change
    create_table :hearts do |t|
      t.integer :dream_id
      t.integer :user_id

      t.timestamps
    end
  end
end
