class ArPullthru < ActiveRecord::Migration[5.1]
  def change
    add_column :availability_requests, :pullthru, :boolean
  end
end
