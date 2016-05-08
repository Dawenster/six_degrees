class AddDreamIdToSummaries < ActiveRecord::Migration
  def change
    add_column :summaries, :dream_id, :integer
  end
end
