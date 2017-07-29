class Payments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :user, foreign_key: true, null: true
      t.string :provider
      t.decimal :total
      t.datetime :paid_at
      t.string :status
      t.string :email
      t.jsonb :params
      t.jsonb :details
      t.timestamps
    end
  end
end
