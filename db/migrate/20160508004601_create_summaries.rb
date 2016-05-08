class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end
end
