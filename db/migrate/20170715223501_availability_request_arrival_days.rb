class AvailabilityRequestArrivalDays < ActiveRecord::Migration[5.1]
  def change
    add_column :availability_requests, :arrival_days, :string, array: true, default: []
  end
end
