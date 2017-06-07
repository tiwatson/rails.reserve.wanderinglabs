class CreateAvailabilityMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :availability_matches do |t|
      t.references :availability_request, foreign_key: true
      t.references :site, foreign_key: true
      t.date :avail_date
      t.integer :length
      t.boolean :available, default: false, null: false
      t.datetime :unavailable_at
      t.datetime :notified_at

      t.timestamps
    end
  end
end
