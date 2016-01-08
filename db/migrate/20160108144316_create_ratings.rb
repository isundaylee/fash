class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :reservation_id
      t.integer :user_id
      t.integer :rating
      t.text :review

      t.timestamps null: false
    end
  end
end
