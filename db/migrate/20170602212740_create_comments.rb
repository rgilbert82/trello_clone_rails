class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :comment
      t.string :user
      t.string :user_initials
      t.string :date_time
      t.integer :user_id
      t.integer :card_id
      t.timestamps
    end
  end
end
