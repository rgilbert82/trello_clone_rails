class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.boolean :comment
      t.string :description
      t.string :date_time
      t.integer :user_id
      t.integer :card_id
      t.timestamps
    end
  end
end
