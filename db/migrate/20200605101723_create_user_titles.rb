class CreateUserTitles < ActiveRecord::Migration[5.2]
  def change
    create_table :user_titles do |t|
      t.integer :user_id
      t.integer :book_shelf_id
      t.integer :title_id
      t.string :volume
      t.timestamps
    end
  end
end
