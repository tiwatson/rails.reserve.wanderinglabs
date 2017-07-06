class FacilityScrape < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :last_import, :datetime
    add_column :facilities, :last_import_hash, :string
  end
end
