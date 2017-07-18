class FacilitSiteCounter < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :sites_count, :integer, default: 0
  end
end
