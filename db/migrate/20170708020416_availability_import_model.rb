class AvailabilityImportModel < ActiveRecord::Migration[5.1]
  def change
    create_table :availability_imports do |t|
      t.references :facility, foreign_key: true
      t.string :run_id
      t.date :date_start
      t.date :date_end
      t.jsonb :history_open
      t.jsonb :history_filled
    end

    change_table :availabilities do |t|
      t.references :availability_import, foreign_key: true
    end

    remove_column :availabilities, :facility_id, :integer
    remove_column :availabilities, :import, :string
  end
end
