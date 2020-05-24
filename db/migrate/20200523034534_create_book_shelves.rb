class CreateBookShelves < ActiveRecord::Migration[5.2]
  def change
    create_table :book_shelves do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.boolean :is_public, null: false, default: true
      t.timestamps
    end
  end
end
