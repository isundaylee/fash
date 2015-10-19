class CreatePreviews < ActiveRecord::Migration
  def change
    create_table :previews do |t|
      t.integer :item_id
      t.attachment :image

      t.timestamps null: false
    end
  end
end
