class CreateAvailabilityRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :availability_requests do |t|
      t.references :user, foreign_key: true
      t.references :facility, foreign_key: true
      t.date :date_start
      t.date :date_end
      t.integer :stay_length
      t.jsonb :details
      t.text :site_ids, array: true, default: '{}'
      t.text :sites_ext_ids, array: true, default: '{}'

      t.timestamps
    end
  end
end
