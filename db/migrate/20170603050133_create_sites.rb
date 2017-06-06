class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.references :facility, foreign_key: true
      t.string :ext_site_id
      t.string :site_num
      t.jsonb :details

      t.timestamps
    end
  end
end
