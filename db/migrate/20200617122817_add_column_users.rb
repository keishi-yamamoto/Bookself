class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_type, :integer, default: 0, null: false
  end
end
