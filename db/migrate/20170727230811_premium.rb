class Premium < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :premium, :boolean, default: false, null: false
    add_column :users, :premium_until, :date
    add_column :users, :priority, :integer, default: 1000
  end
end
