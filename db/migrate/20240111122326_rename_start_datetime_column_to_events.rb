class RenameStartDatetimeColumnToEvents < ActiveRecord::Migration[7.1]
  def change
    rename_column :events, :start_datetime, :start_time
  end
end
