class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.string :title
      t.boolean :archived
      t.integer :position
      t.integer :user_id
      t.integer :board_id
      t.timestamps
    end
  end
end
