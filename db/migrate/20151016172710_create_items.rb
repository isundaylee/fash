class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :size
      t.integer :gender
      t.string :category
      t.string :brand
      t.decimal :price
      t.decimal :insurance_claim
      t.string :color
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
