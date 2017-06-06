class CreateFacilities < ActiveRecord::Migration[5.1]
  def change
    create_table :facilities do |t|
      t.references :agency, foreign_key: true
      t.string :name
      t.string :type
      t.jsonb :details

      t.timestamps
    end
  end
end
