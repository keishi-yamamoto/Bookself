class CreateBookSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :book_series do |t|
      t.integer :book_shelf_id
      t.string :name, null: false
      t.string :author
      t.string :publisher
      t.integer :total_amount
      t.integer :amount
      t.timestamps
    end
  end
end
