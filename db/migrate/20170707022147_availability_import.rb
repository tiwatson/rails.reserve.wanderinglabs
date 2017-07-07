class AvailabilityImport < ActiveRecord::Migration[5.1]
  def change
    add_column :availabilities, :import, :string
    remove_column :availabilities, :scrape, :string
  end
end
