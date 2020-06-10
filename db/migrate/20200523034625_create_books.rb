class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer :title_id, null: false
      t.integer :number
      t.timestamps
    end
  end
end
