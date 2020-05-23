class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer :book_series_id, null: false
      t.string :name, null: false
      t.integer :number
      t.timestamps
    end
  end
end
