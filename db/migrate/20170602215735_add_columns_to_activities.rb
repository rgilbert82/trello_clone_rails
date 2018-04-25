class AddColumnsToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :user_name, :string
    add_column :activities, :user_initials, :string
  end
end
