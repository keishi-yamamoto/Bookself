class CreateTitles < ActiveRecord::Migration[5.2]
  def change
    create_table :titles do |t|
      t.string :name, null: false
      t.string :author
      t.string :publisher

      t.timestamps
    end
  end
end
