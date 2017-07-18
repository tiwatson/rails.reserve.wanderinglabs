class FacilityStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :status, :string
  end
end
