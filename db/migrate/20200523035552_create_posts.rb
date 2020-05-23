class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :book_id, null: false
      t.string :content, null: false
      t.timestamps
    end
  end
end
