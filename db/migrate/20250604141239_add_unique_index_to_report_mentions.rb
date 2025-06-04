class AddUniqueIndexToReportMentions < ActiveRecord::Migration[7.0]
  def change
    add_index :report_mentions, [:source_report_id, :target_report_id], unique: true
  end
end
