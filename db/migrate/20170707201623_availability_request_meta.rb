class AvailabilityRequestMeta < ActiveRecord::Migration[5.1]
  def change
    add_column :availability_requests, :checked_count, :integer, default: 0
    add_column :availability_requests, :checked_at, :datetime
    add_column :availability_requests, :status, :string
  end
end
