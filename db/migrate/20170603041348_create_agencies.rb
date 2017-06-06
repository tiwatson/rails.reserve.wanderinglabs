class CreateAgencies < ActiveRecord::Migration[5.1]
  def change
    create_table :agencies do |t|
      t.string :name
      t.jsonb :details

      t.timestamps
    end
  end
end
