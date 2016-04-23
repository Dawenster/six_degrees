class CreateDreamsTags < ActiveRecord::Migration
  def change
    create_table :dreams_tags do |t|
      t.integer :dream_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
