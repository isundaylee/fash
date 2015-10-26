class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :item_id
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :reservations, :deleted_at
  end
end
