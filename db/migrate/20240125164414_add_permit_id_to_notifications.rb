class AddPermitIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :permit, foreign_key: true
    
  end
end
