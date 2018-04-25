class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :title
      t.string :description
      t.text :labels
      t.text :due_date
      t.boolean :due_date_highlighted
      t.boolean :archived
      t.integer :position
      t.integer :user_id
      t.integer :list_id
      t.timestamps
    end
  end
end
