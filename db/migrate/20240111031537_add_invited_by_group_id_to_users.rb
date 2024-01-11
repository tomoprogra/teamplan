class AddInvitedByGroupIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :invited_by_group_id, :integer
  end
end
