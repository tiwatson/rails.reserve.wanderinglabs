class ArUuid < ActiveRecord::Migration[5.1]
  def change
    add_column :availability_requests, :uuid, :uuid, null: false, default: 'uuid_generate_v4()'
    add_index :availability_requests, :uuid, unique: true
  end
end
