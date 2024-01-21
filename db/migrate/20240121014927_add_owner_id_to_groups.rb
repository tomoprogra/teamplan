class AddOwnerIdToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :owner_id, :integer
    add_foreign_key :groups, :users, column: :owner_id
  end
end
