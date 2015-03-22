class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.text :initial_message
      t.boolean :accepted, :default => false
      t.integer :dream_id
      t.integer :user_id

      t.timestamps
    end
  end
end
