class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
