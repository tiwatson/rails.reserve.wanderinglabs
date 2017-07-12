class AvailabilityMatchTracking < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_methods do |t|
      t.references :user, foreign_key: true
      t.string :type
      t.string :param
      t.jsonb :details
    end

    create_table :availability_notifications do |t|
      t.references :availability_request, foreign_key: true
      t.references :notification_method, foreign_key: true
      t.jsonb :matches_new
      t.jsonb :matches
      t.timestamps
    end

    create_table :availability_match_clicks do |t|
      t.references :availability_match, foreign_key: true
      t.string :from
      t.boolean :available, default: false, null: false
      t.integer :elapsed_time
      t.timestamps
    end
  end
end
