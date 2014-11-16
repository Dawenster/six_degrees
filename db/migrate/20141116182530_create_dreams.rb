class CreateDreams < ActiveRecord::Migration
  def change
    create_table :dreams do |t|
      t.string :description
      t.string :dream_type

      t.timestamps
    end
  end
end
