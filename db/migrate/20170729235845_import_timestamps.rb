class ImportTimestamps < ActiveRecord::Migration[5.1]
  def change
    add_column :availability_imports, :created_at, :datetime
  end
end
