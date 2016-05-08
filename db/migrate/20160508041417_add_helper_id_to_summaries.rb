class AddHelperIdToSummaries < ActiveRecord::Migration
  def change
    add_column :summaries, :helper_id, :integer
  end
end
