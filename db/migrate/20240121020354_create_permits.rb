class CreatePermits < ActiveRecord::Migration[7.1]
  def change
    create_table :permits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
