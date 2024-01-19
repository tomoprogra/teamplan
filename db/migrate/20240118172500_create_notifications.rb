class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :group_id
      t.integer :chat_id
      t.string :action, null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end

      add_index :notifications, :visitor_id
      add_index :notifications, :visited_id
      add_index :notifications, :group_id
      add_index :notifications, :chat_id
  end
end
