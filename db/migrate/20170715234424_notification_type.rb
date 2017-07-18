class NotificationType < ActiveRecord::Migration[5.1]
  def change
    add_column :notification_methods, :notification_type, :string
    remove_column :notification_methods, :type, :string
  end
end
