class ArSearch < ActiveRecord::Migration[5.1]
  def change
    add_column :availability_requests, :water, :boolean
    add_column :availability_requests, :sewer, :boolean
    add_column :availability_requests, :min_electric, :integer
    add_column :availability_requests, :min_length, :integer
    add_column :availability_requests, :site_type, :string
    add_column :availability_requests, :specific_site_ids, :text

    add_column :sites, :water, :boolean, default: false, null: false
    add_column :sites, :sewer, :boolean, default: false, null: false
    add_column :sites, :electric, :integer
    add_column :sites, :length, :integer
    add_column :sites, :site_type, :string
  end
end
