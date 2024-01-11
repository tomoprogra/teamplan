class RenameEndDatetimeColumnToEvents < ActiveRecord::Migration[7.1]
  def change
    rename_column :events, :end_datetime, :end_time
  end
end
