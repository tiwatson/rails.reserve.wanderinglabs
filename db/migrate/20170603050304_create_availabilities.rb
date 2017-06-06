class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.references :facility, foreign_key: true
      t.references :site, foreign_key: true
      t.string :scrape
      t.date :avail_date

      t.timestamps
    end
  end
end
