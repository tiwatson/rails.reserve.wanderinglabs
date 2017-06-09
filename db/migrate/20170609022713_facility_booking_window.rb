class FacilityBookingWindow < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :booking_window, :integer
  end
end
